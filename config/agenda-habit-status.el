;;; agenda-habit-status.el --- Show today's completed habits -*- lexical-binding: t -*-

(require 'org-agenda)
(require 'org-habit)

;; Keep today's completed habits visible after their schedule advances.
(setq org-habit-show-all-today t)

(defun praharsh-org-habit-done-today-p (marker)
  "Return non-nil if MARKER's habit was completed on the current Org day."
  (when (and (markerp marker) (marker-buffer marker))
    (org-with-point-at marker
      (when (org-is-habit-p)
        (when-let* ((last-repeat (org-entry-get nil "LAST_REPEAT")))
          (org-agenda-today-p (ignore-errors (org-time-string-to-absolute last-repeat))))))))

(defun praharsh-org-agenda-habit-status ()
  "Display DONE for today's completed habit occurrences, preserving repeats."
  (let ((inhibit-read-only t))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (when (and (org-agenda-today-p (org-get-at-bol 'day))
                   (praharsh-org-habit-done-today-p (org-get-at-bol 'org-hd-marker)))
          (when-let* ((heading (text-property-any (line-beginning-position)
                                                 (line-end-position) 'org-heading t))
                      (regexp (org-get-at-bol 'org-todo-regexp)))
            (goto-char heading)
            (when (looking-at (concat "[ \t]*\\.*\\(" regexp "\\) +"))
              (let ((start (match-beginning 1)))
                (replace-match (apply #'propertize "DONE" (text-properties-at start)) t t nil 1)
                (remove-text-properties start (+ start 4) '(display nil invisible nil))
                (add-text-properties (line-beginning-position) (line-end-position)
                                     '(todo-state "DONE" face org-agenda-done))
                (put-text-property start (+ start 4) 'face 'org-done)))))
        (forward-line 1)))))

;; Run before org-modern so its labels reflect the displayed occurrence state.
(add-hook 'org-agenda-finalize-hook #'praharsh-org-agenda-habit-status -90)

(provide 'agenda-habit-status)
;;; agenda-habit-status.el ends here
