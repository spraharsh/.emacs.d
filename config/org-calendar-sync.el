;;; org-calendar-sync.el --- Sync saved Org tasks through the desktop login -*- lexical-binding: t -*-
(require 'cl-lib)
(require 'ox-icalendar)

(defvar praharsh-org-calendar-source "44c5ce5d801c35d429a2edacae748152f8289f1d"
  "Evolution Data Server UID of the signed-in Google Org-calendar.")
(defvar praharsh-org-calendar-process nil)
(defvar praharsh-org-calendar-last-success nil)
(defvar praharsh-org-calendar-status "Not synced yet")

(defun praharsh-org-calendar-export ()
  "Return active dated non-habit tasks as ICS, without editing agenda files.
Org handles dates, ranges and repeaters.  Only saved text is exported."
  (let* ((org-agenda-skip-unavailable-files nil)
         (files (org-agenda-files t))
        (org-export-use-babel nil)
        (org-export-allow-bind-keywords nil)
        (org-icalendar-include-sexps nil)
        (org-icalendar-include-body nil)
        (original-entry (symbol-function 'org-icalendar-entry)))
    (unless files (error "No agenda files configured; refusing calendar cleanup"))
    (cl-letf (((symbol-function 'org-macro-replace-all) #'ignore)
              ((symbol-function 'org-export-expand-include-keyword) #'ignore)
              ((symbol-function 'org-icalendar-entry)
               (lambda (entry contents info)
                 (if (and (eq (org-element-property :todo-type entry) 'todo)
                          (not (equal (org-element-property :STYLE entry) "habit")))
                     (funcall original-entry entry contents
                              (plist-put info :with-timestamps 'active))
                   contents))))
      (concat
       "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Org agenda sync//EN\n"
       (mapconcat
        (lambda (file)
          (let ((before (file-attributes file))
                (seen (make-hash-table :test #'equal)))
            (unless before (error "Missing agenda file: %s" file))
            (with-temp-buffer
              (insert-file-contents file)
              ;; Reading may change access time; compare the content metadata.
              (unless (equal (list (file-attribute-modification-time before)
                                   (file-attribute-size before))
                             (let ((after (file-attributes file)))
                               (list (file-attribute-modification-time after)
                                     (file-attribute-size after))))
                (error "Agenda file changed during export: %s" file))
              (let ((org-mode-hook nil) (org-inhibit-startup t)) (org-mode))
              (org-map-entries
               (lambda ()
                 (let* ((path (org-get-outline-path t))
                        (ordinal (gethash path seen 0)))
                   (puthash path (1+ ordinal) seen)
                   (when (member (org-get-todo-state) org-not-done-keywords)
                     ;; ponytail: path identity; renames/moves replace the event.
                     ;; Set an Org ID if identity must survive either change.
                     (org-entry-put
                      nil "ID"
                      (or (org-entry-get nil "ID")
                          (secure-hash 'sha256
                                       (prin1-to-string
                                        (list (file-truename file) path ordinal)))))))))
              (org-export-as
               'icalendar nil nil t
               '(:with-timestamps active :icalendar-include-todo nil
                 :icalendar-use-scheduled (event-if-todo-not-done)
                 :icalendar-use-deadline (event-if-todo-not-done)
                 :icalendar-scheduled-summary-prefix ""
                 :icalendar-deadline-summary-prefix "Deadline: "
                 :ascii-charset utf-8 :ascii-links-to-notes nil)))))
        files "")
       "END:VCALENDAR\n"))))

(defun praharsh-org-calendar-sync ()
  "Sync changed saved agenda tasks asynchronously; retry failures next refresh."
  (interactive)
  (unless (process-live-p praharsh-org-calendar-process)
    (condition-case err
        (let* ((ics (praharsh-org-calendar-export))
               (digest (secure-hash 'sha256
                                    (replace-regexp-in-string "^DTSTAMP:.*\n" "" ics))))
          (unless (equal digest praharsh-org-calendar-last-success)
            (let* ((file (make-temp-file "org-calendar-" nil ".ics"))
                   (buffer (get-buffer-create "*Org calendar sync*"))
                   (timeout nil))
              (let ((coding-system-for-write 'utf-8-unix))
                (write-region ics nil file nil 'silent))
              (with-current-buffer buffer (erase-buffer))
              (condition-case spawn-error
                  (setq praharsh-org-calendar-process
                        (make-process
                         :name "org-calendar-sync" :buffer buffer
                         :connection-type 'pipe :noquery t
                         :command (list "/usr/bin/python3"
                                        (expand-file-name "config/org-calendar-sync.py" user-emacs-directory)
                                        praharsh-org-calendar-source file)
                         :sentinel
                         (lambda (process _event)
                           (when (memq (process-status process) '(exit signal))
                             (when (timerp timeout) (cancel-timer timeout))
                             (when (file-exists-p file) (delete-file file))
                             (setq praharsh-org-calendar-process nil
                                   praharsh-org-calendar-status
                                   (with-current-buffer buffer (string-trim (buffer-string))))
                             (if (and (eq (process-status process) 'exit)
                                      (= 0 (process-exit-status process)))
                                 (setq praharsh-org-calendar-last-success digest)
                               (message "Org calendar sync failed: %s" praharsh-org-calendar-status))))))
                (error (delete-file file) (signal (car spawn-error) (cdr spawn-error))))
              (setq praharsh-org-calendar-status "Syncing"
                    timeout (run-at-time 50 nil
                                         (lambda ()
                                           (when (process-live-p praharsh-org-calendar-process)
                                             (delete-process praharsh-org-calendar-process))))))))
      (error (setq praharsh-org-calendar-status (error-message-string err))
             (message "Org calendar sync skipped: %s" praharsh-org-calendar-status)))))

(provide 'org-calendar-sync)
;;; org-calendar-sync.el ends here
