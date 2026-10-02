;;; org-calendar-sync-test.el --- Org calendar export check -*- lexical-binding: t -*-
;; Run: emacs -Q --batch -l ~/.emacs.d/test/org-calendar-sync-test.el -f ert-run-tests-batch-and-exit
(require 'ert)
(require 'cl-lib)
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
(require 'org-calendar-sync nil t)
(defvar org-calendar-test-evaluated nil)

(ert-deftest org-calendar-sync-exports-active-dates-with-stable-identities ()
  (should (fboundp 'praharsh-org-calendar-export))
  (let* ((file (make-temp-file "org-calendar-" nil ".org"))
         (included (make-temp-file "org-calendar-include-" nil ".org"))
         (org-agenda-files (list file))
         (org-calendar-test-evaluated nil)
         (text "#+TODO: TODO WAIT | DONE CANCELED\n#+TODO: TOREAD | READ\n* Notes\n<2026-10-02 Fri>\n** TODO Habit\nSCHEDULED: <2026-10-02 Fri +1d>\n:PROPERTIES:\n:STYLE: habit\n:END:\nPrivate body\n[2026-10-01 Thu]\n** TOREAD Paper\nSCHEDULED: <2026-10-04 Sun 09:00-10:30>\n** WAIT Reply\nDEADLINE: <2026-10-03 Sat>\n** TODO Undated\n** DONE Finished\nSCHEDULED: <2026-10-02 Fri>\n<2026-10-03 Sat>\n** READ Read paper\nDEADLINE: <2026-10-02 Fri>\n"))
    (unwind-protect
        (progn
          (with-temp-file included (insert "* TODO Included\nSCHEDULED: <2026-10-02 Fri>\n"))
          (setq text (concat text "** TODO Repeating task\nSCHEDULED: <2026-10-02 Fri +1d>\n"))
          (setq text (concat "#+OPTIONS: <:t\n#+MACRO: unsafe (eval (progn (setq org-calendar-test-evaluated t) \"\"))\n"
                             (format "#+INCLUDE: \"%s\"\n" included)
                             (replace-regexp-in-string "TODO Repeating task" "TODO Repeating task {{{unsafe}}}" text t t)))
          (with-temp-file file (insert text))
          (let* ((ics (praharsh-org-calendar-export))
                 (uids (split-string ics "\n" t))
                 (ids (cl-remove-if-not (lambda (line) (string-prefix-p "UID:" line)) uids)))
            (should (= 3 (cl-count "BEGIN:VEVENT" uids :test #'equal)))
            (should-not org-calendar-test-evaluated)
            (let ((restriction (get 'org-agenda-files 'org-restrict)))
              (unwind-protect
                  (progn
                    (put 'org-agenda-files 'org-restrict (list included))
                    (should (string-match-p "SUMMARY:Paper" (praharsh-org-calendar-export))))
                (put 'org-agenda-files 'org-restrict restriction)))
            (should (string-match-p "RRULE:FREQ=DAILY;INTERVAL=1" ics))
            (should (string-match-p "DTSTART;VALUE=DATE:20261003" ics))
            (should (string-match-p "DTEND;VALUE=DATE:20261004" ics))
            (should (string-match-p "SUMMARY:Paper" ics))
            (should (string-match-p "SUMMARY:Repeating task" ics))
            (should-not (string-match-p "SUMMARY:Habit\\|Private body\\|Finished\\|Read paper\\|SUMMARY:Notes\\|Undated\\|BEGIN:VTODO" ics))
            (should (equal ids (cl-remove-if-not
                               (lambda (line) (string-prefix-p "UID:" line))
                               (split-string (praharsh-org-calendar-export) "\n" t))))
            (with-temp-file file
              (insert (replace-regexp-in-string "2026-10-02 Fri +1d" "2026-10-05 Mon +1d" text t t)))
            (should (equal ids (cl-remove-if-not
                               (lambda (line) (string-prefix-p "UID:" line))
                               (split-string (praharsh-org-calendar-export) "\n" t))))
            (with-temp-buffer
              (insert-file-contents file)
              (should-not (string-match-p ":ID:" (buffer-string))))
            (delete-file file)
            (should-error (praharsh-org-calendar-export))))
      (when (file-exists-p file) (delete-file file))
      (delete-file included))))
