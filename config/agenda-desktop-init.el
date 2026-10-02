;;; agenda-desktop-init.el --- Emacs for the desktop agenda -*- lexical-binding: t -*-
;; Launched separately with -Q; this never changes the main Emacs session.
(require 'server)
(unless noninteractive
  (setq server-name "agenda-desktop")
  (unless (server-running-p server-name) (server-start)))
(unless noninteractive (package-initialize))
(require 'org-agenda)
(require 'org-habit)
(require 'filenotify)
(require 'agenda-habit-status
         (expand-file-name "config/agenda-habit-status.el" user-emacs-directory))

(defvar praharsh-agenda-desktop-cache
  (expand-file-name "emacs-agenda-desktop/" (or (getenv "XDG_CACHE_HOME") "~/.cache")))
(defvar praharsh-agenda-desktop-save-timer nil)
(defvar praharsh-agenda-desktop-frame nil)
(defvar praharsh-agenda-desktop-stamp nil)
(defvar praharsh-agenda-desktop-history :unloaded)

(defconst praharsh-agenda-desktop-colors
  '((canvas . "#002b36") (surface . "#073642")
    (text . "#cad8d9") (secondary . "#adbcbc") (muted . "#72898f")
    (today . "#41c7b9") (pending . "#58a3ff") (done . "#84c747")
    (deadline . "#dbb32d") (waiting . "#af88eb"))
  "Solarized surfaces with Selenized text and semantic accents.")

(defun praharsh-agenda-desktop-color (role)
  (alist-get role praharsh-agenda-desktop-colors))

(defun praharsh-agenda-desktop-style-frame ()
  "Apply the desktop planner's SF Pro typography and semantic colors."
  (require 'org-modern)
  (set-face-attribute 'default nil :family "SF Pro Text" :height 120
                      :background (praharsh-agenda-desktop-color 'canvas)
                      :foreground (praharsh-agenda-desktop-color 'text))
  (dolist (face '(org-scheduled org-scheduled-today org-agenda-dimmed-todo-face org-habit-clear-face))
    (set-face-attribute face nil :foreground (praharsh-agenda-desktop-color 'text)
                        :background 'unspecified :weight 'normal))
  (set-face-attribute 'org-agenda-done nil :foreground (praharsh-agenda-desktop-color 'secondary)
                      :weight 'normal :strike-through nil)
  (dolist (face '(org-upcoming-deadline org-imminent-deadline org-warning))
    (set-face-attribute face nil :foreground (praharsh-agenda-desktop-color 'deadline)
                        :weight 'normal))
  (set-face-attribute 'org-modern-label nil :family "SF Pro Text" :height 0.85
                      :width 'normal :weight 'semibold :inverse-video nil)
  (setq org-modern-todo-faces
        (mapcar (lambda (state)
                  (cons (car state)
                        (list :foreground (praharsh-agenda-desktop-color (cdr state))
                              :background (praharsh-agenda-desktop-color 'surface)
                              :inverse-video nil :weight 'semibold)))
                '(("TODO" . pending) ("TOREAD" . pending) ("WAIT" . waiting)
                  ("DONE" . done) ("READ" . done) ("CANCELED" . secondary)))))

(defun praharsh-agenda-desktop-style-buffer ()
  "Give native agenda dates a compact calendar hierarchy without losing markers."
  (let ((inhibit-read-only t) dates)
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (when (and (org-get-at-bol 'org-agenda-date-header) (not (eolp)))
          (let* ((day (org-get-at-bol 'day))
                 (today (org-agenda-today-p day))
                 (date (calendar-gregorian-from-absolute day))
                 (time (encode-time 0 0 12 (nth 1 date) (car date) (nth 2 date)))
                 (properties (text-properties-at (line-beginning-position)))
                 (color (praharsh-agenda-desktop-color (if today 'today 'secondary))))
            (push day dates)
            (delete-region (line-beginning-position) (line-end-position))
            (insert (propertize (format-time-string "%d" time)
                                'face (list :family "SF Pro Display" :height 1.45
                                            :weight 'semibold :foreground color))
                    (propertize (format-time-string "   %A" time)
                                'face (list :family "SF Pro Text" :height 1.0
                                            :weight 'medium :foreground color))
                    (if today
                        (propertize "   TODAY" 'face (list :height 0.7 :weight 'semibold
                                                         :foreground color)) ""))
            (cl-remf properties 'face)
            (add-text-properties (line-beginning-position) (line-end-position) properties)
            (when today
              (add-face-text-property (line-beginning-position) (1+ (line-end-position))
                                      (list :background (praharsh-agenda-desktop-color 'surface) :extend t) t))
            (put-text-property (line-beginning-position) (1+ (line-end-position)) 'line-spacing 0.4)))
        (when (org-get-at-bol 'org-hd-marker)
          (put-text-property (line-beginning-position) (1+ (line-end-position)) 'line-spacing 0.4)
          (when (equal (org-get-at-bol 'type) "deadline")
            (add-face-text-property (line-beginning-position) (line-end-position)
                                    (list :foreground (praharsh-agenda-desktop-color 'deadline)) t)))
        (when (= (line-beginning-position) (line-end-position))
          (add-text-properties (point) (1+ (point)) '(face (:height 0.55) line-spacing 0.1)))
        (forward-line 1))
      (goto-char (point-min))
      (delete-region (point) (line-beginning-position 2))
      (let* ((first (car (last dates)))
             (last (car dates))
             (format-day (lambda (day)
                           (let ((date (calendar-gregorian-from-absolute day)))
                             (encode-time 0 0 12 (nth 1 date) (car date) (nth 2 date))))))
        (insert (propertize "Agenda" 'agenda-desktop-open t
                            'face (list :family "SF Pro Display" :height 2.0 :weight 'semibold
                                        :foreground (praharsh-agenda-desktop-color 'text)))
                (propertize "  ↗\n" 'agenda-desktop-open t
                            'face (list :height 1.0 :foreground (praharsh-agenda-desktop-color 'today)))
                (propertize (if first
                                (format "%s — %s  ·  W%s\n"
                                        (format-time-string "%d %b" (funcall format-day first))
                                        (format-time-string "%d %b %Y" (funcall format-day last))
                                        (format-time-string "%V" (funcall format-day first)))
                              (format-time-string "%B %Y\n"))
                            'face (list :height 0.85 :foreground (praharsh-agenda-desktop-color 'secondary))))))))

(defun praharsh-agenda-desktop-history ()
  "Read the private habit undo records without evaluating them."
  (when (eq praharsh-agenda-desktop-history :unloaded)
    (setq praharsh-agenda-desktop-history
          (let ((file (expand-file-name "habit-undo.el" praharsh-agenda-desktop-cache)))
            (when (file-exists-p file)
              (with-temp-buffer (insert-file-contents file) (read (current-buffer)))))))
  praharsh-agenda-desktop-history)

(defun praharsh-agenda-desktop-save-history (history)
  "Save HISTORY atomically before committing a habit completion."
  (let ((temporary (make-temp-file (expand-file-name "habit-undo-" praharsh-agenda-desktop-cache))))
    (unwind-protect
        (let ((coding-system-for-write 'utf-8-unix)
              (print-length nil) (print-level nil))
          (write-region (prin1-to-string history) nil temporary nil 'silent)
          (rename-file temporary (expand-file-name "habit-undo.el" praharsh-agenda-desktop-cache) t)
          (setq praharsh-agenda-desktop-history history))
      (when (file-exists-p temporary) (delete-file temporary)))))

(defun praharsh-agenda-desktop-habit-key ()
  "Identify the current habit without adding metadata to the todo file."
  (let ((path (org-get-outline-path t)) (count 0))
    (org-map-entries
     (lambda () (when (equal path (org-get-outline-path t)) (cl-incf count))) nil 'file)
    (unless (= count 1)
      (user-error "Habit headings must have unique paths for click undo"))
    (list (file-truename buffer-file-name) path)))

(defun praharsh-agenda-desktop-entry-text ()
  "Return the current entry's text, excluding child entries."
  (buffer-substring-no-properties (line-beginning-position) (org-entry-end-position)))

(defun praharsh-agenda-desktop-build ()
  "Build the real weekly Org agenda, reloading saved changes first."
  (dolist (file (org-agenda-files))
    (when-let* ((buffer (get-file-buffer file)))
      (with-current-buffer buffer
        (unless (or (buffer-modified-p) (verify-visited-file-modtime buffer))
          (revert-buffer t t)))))
  (save-window-excursion
    (save-current-buffer
      (let ((org-agenda-window-setup 'current-window)
            (org-agenda-sticky nil))
        ;; Keep habit tasks; their wide graphs overwrite text in a narrow card.
        (cl-letf (((symbol-function 'org-habit-insert-consistency-graphs) #'ignore))
		 (org-agenda-list))
        (praharsh-agenda-desktop-style-buffer)
        (setq-local mode-line-format nil
                    header-line-format nil
                    cursor-type nil
                    truncate-lines nil
                    line-spacing 0.18
                    face-remapping-alist '((default (:family "SF Pro Text" :height 120) default)))
        (visual-line-mode 1)
        (display-line-numbers-mode -1)
        ;; Org's read-only agenda normally still has commands that edit tasks.
        (use-local-map special-mode-map)
        (setq buffer-read-only t)
        (current-buffer)))))

(defun praharsh-agenda-desktop-toggle-task (marker)
  "Toggle MARKER's task and save it, refusing unsaved or replaced data."
  (unless (and (markerp marker) (marker-buffer marker))
    (user-error "The agenda changed; click the task again"))
  (with-current-buffer (marker-buffer marker)
    (unless (and buffer-file-name (member buffer-file-name (org-agenda-files)))
      (user-error "This is not an agenda task"))
    (when (or (buffer-modified-p) (stringp (file-locked-p buffer-file-name)))
      (user-error "This task is being edited; save it in Emacs first"))
    (unless (and (file-exists-p buffer-file-name)
                 (verify-visited-file-modtime (current-buffer)))
      (user-error "The todo file changed; click again after the agenda refreshes"))
    (save-window-excursion
      (save-excursion
        (goto-char marker)
        (org-back-to-heading t)
        (let* ((state (org-get-todo-state))
               (reopen (member state org-done-keywords))
               (habit-key (when (org-is-habit-p) (praharsh-agenda-desktop-habit-key)))
               (before (praharsh-agenda-desktop-entry-text))
               (undo-habit (and habit-key (praharsh-org-habit-done-today-p marker)))
               (record (when undo-habit
                         (cdr (assoc habit-key (praharsh-agenda-desktop-history))))))
          (when (or undo-habit reopen (member state org-not-done-keywords))
            (when (and undo-habit
                       (not (and (= (or (plist-get record :day) -1) (org-today))
				 (equal before (plist-get record :after)))))
              (user-error "The habit changed since completion; its previous state cannot be safely restored"))
            (let ((org-inhibit-logging 'note)
                  (org-log-done 'time)
                  (org-log-repeat 'time)
                  (refuse (lambda (&rest _)
                            (user-error "This change needs confirmation; complete it in Emacs"))))
              ;; A concurrent save/lock must never open a hidden prompt or overwrite it.
              (cl-letf (((symbol-function 'yes-or-no-p) refuse)
			((symbol-function 'y-or-n-p) refuse)
			((symbol-function 'ask-user-about-lock) refuse)
			((symbol-function 'ask-user-about-supersession-threat) refuse))
		       (condition-case err
			   (atomic-change-group
			     (if undo-habit
				 (let ((start (point)))
				   (delete-region start (org-entry-end-position))
				   (insert (plist-get record :before))
				   (goto-char start))
			       (org-todo (if reopen (car org-not-done-keywords) 'done)))
			     (when org-log-setup
			       (let ((org-log-note-how 'time)) (org-add-log-note)))
			     (when (and habit-key (not undo-habit) (not reopen))
			       ;; save-buffer adds this newline; record the same bytes.
			       (save-excursion
				 (goto-char (point-max))
				 (when (and (memq require-final-newline '(t visit-save)) (not (bolp)))
				   (insert "\n")))
			       (org-back-to-heading t)
			       (praharsh-agenda-desktop-save-history
				(cons (cons habit-key (list :day (org-today) :before before
							    :after (praharsh-agenda-desktop-entry-text)))
				      (assoc-delete-all habit-key (praharsh-agenda-desktop-history)))))
			     (unless (verify-visited-file-modtime (current-buffer))
			       (user-error "The todo file changed while completing this task"))
			     (save-buffer))
			 (error
			  (remove-hook 'post-command-hook #'org-add-log-note)
			  (setq org-log-setup nil)
			  (signal (car err) (cdr err))))))
            (when undo-habit
              (condition-case err
                  (praharsh-agenda-desktop-save-history
                   (assoc-delete-all habit-key (praharsh-agenda-desktop-history)))
		(error (message "Habit restored; undo cache cleanup failed: %s" (error-message-string err)))))
            (if (or reopen undo-habit) 'todo 'done)))))))

(defun praharsh-agenda-desktop-click (x y stamp)
  "Handle a click on the rendered PNG, only if STAMP matches that image."
  (let* ((png (expand-file-name "agenda.png" praharsh-agenda-desktop-cache))
         (attributes (file-attributes png))
         (frame praharsh-agenda-desktop-frame))
    (if (or (not (integerp stamp)) (not (equal stamp praharsh-agenda-desktop-stamp))
            (not attributes)
            (/= stamp (car (time-convert (file-attribute-modification-time attributes) 1000000000))))
        (progn (praharsh-agenda-desktop-refresh) 'stale)
      (when (and (frame-live-p frame) (integerp x) (integerp y)
                 (<= 0 x) (< x (frame-pixel-width frame))
                 (<= 0 y) (< y (frame-pixel-height frame)))
        (let* ((window (get-buffer-window "*Org Agenda*" frame))
               (position (posn-at-x-y x y frame))
               (point (posn-point position)))
          (when (and window (eq window (posn-window position))
                     (null (posn-area position)) (integerp point))
            (with-current-buffer (window-buffer window)
              (save-excursion
                (goto-char point)
                (cond
                 ((get-text-property (point) 'agenda-desktop-open) 'open)
                 ((org-get-at-bol 'org-hd-marker)
                  (condition-case err
                      (prog1 (praharsh-agenda-desktop-toggle-task (org-get-at-bol 'org-hd-marker))
                        (with-selected-frame frame (praharsh-agenda-desktop-refresh)))
                    (error
                     (with-selected-frame frame (praharsh-agenda-desktop-refresh))
                     (signal (car err) (cdr err))))))))))))))

(defun praharsh-agenda-desktop-refresh ()
  "Render the agenda atomically for the background surface."
  ;; Old pixels stop accepting clicks as soon as the agenda starts rebuilding.
  (setq praharsh-agenda-desktop-stamp nil)
  (condition-case err
      (let ((buffer (praharsh-agenda-desktop-build))
            (temporary (make-temp-file (expand-file-name "agenda-" praharsh-agenda-desktop-cache) nil ".png")))
        (unwind-protect
            (progn
              (setq praharsh-agenda-desktop-frame (selected-frame))
              (set-window-buffer (selected-window) buffer)
              (set-window-start (selected-window) 1)
              (redraw-frame praharsh-agenda-desktop-frame)
              (redisplay t)
              (let ((coding-system-for-write 'binary))
                (write-region (x-export-frames nil 'png) nil temporary nil 'silent))
              (let ((png (expand-file-name "agenda.png" praharsh-agenda-desktop-cache)))
                (rename-file temporary png t)
                (setq praharsh-agenda-desktop-stamp
                      (car (time-convert (file-attribute-modification-time (file-attributes png)) 1000000000)))))
          (when (file-exists-p temporary) (delete-file temporary))))
    (error (message "Desktop agenda refresh failed: %s" (error-message-string err)))))

(defun praharsh-agenda-desktop-file-changed (event)
  "Refresh after a todo save, including saves using atomic rename."
  (when (cl-some (lambda (path)
                   (and (stringp path)
                        (member (expand-file-name path) (org-agenda-files))))
                 (cddr event))
    (when (timerp praharsh-agenda-desktop-save-timer)
      (cancel-timer praharsh-agenda-desktop-save-timer))
    (setq praharsh-agenda-desktop-save-timer
          (run-at-time 0.35 nil #'praharsh-agenda-desktop-refresh))))

(unless noninteractive
  (require 'use-package)
  (add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
  ;; Reuse task states, scheduling behavior, and org-modern from the main init.
  (defun praharsh-prog-fonts ()
    (face-remap-add-relative 'default :family "SF Pro Text" :height 120))
  (require 'init-org)
  ;; The display must not read or overwrite the main session's clock history.
  (setq org-clock-persist nil)
  (remove-hook 'org-mode-hook #'org-clock-load)
  (remove-hook 'kill-emacs-hook #'org-clock-save)
  ;; Read only the agenda-file setting from Emacs Custom in the main init.
  (with-temp-buffer
    (insert-file-contents (expand-file-name "init.el" user-emacs-directory))
    (goto-char (point-min))
    (condition-case nil
        (while t
          (let ((form (read (current-buffer))))
            (when (eq (car-safe form) 'custom-set-variables)
              (dolist (setting (cdr form))
                (when (eq (caadr setting) 'org-agenda-files)
                  (setq org-agenda-files (eval (cadadr setting) t)))))))
      (end-of-file nil)))
  (load-theme 'doom-solarized-dark t)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setq frame-title-format "Org Agenda Renderer"
        frame-resize-pixelwise t
        org-agenda-span 'week
        org-agenda-prefix-format '((agenda . "  %?-5t% s"))
        org-agenda-format-date "\n%A  ·  %d %B"
        org-agenda-time-grid nil
        org-agenda-current-time-string "──────── now ────────"
        org-agenda-show-all-dates t
        org-agenda-tags-column 0)
  (modify-frame-parameters nil '((title . "Org Agenda Renderer")
                                 (background-color . "#002b36")
                                 (foreground-color . "#eee8d5")
                                 (internal-border-width . 22)
                                 (left-fringe . 0) (right-fringe . 0)))
  (praharsh-agenda-desktop-style-frame)
  ;; Pixel dimensions here exclude the two 22px internal borders.
  (set-frame-size nil 476 776 t)
  (make-directory praharsh-agenda-desktop-cache t)
  (set-file-modes praharsh-agenda-desktop-cache #o700)
  (dolist (directory (delete-dups (mapcar #'file-name-directory (org-agenda-files))))
    (file-notify-add-watch directory '(change) #'praharsh-agenda-desktop-file-changed))
  (praharsh-agenda-desktop-refresh)
  ;; The timer also updates the date at midnight and notices missed file events.
  (run-at-time 60 60 #'praharsh-agenda-desktop-refresh))

;;; agenda-desktop-init.el ends here
