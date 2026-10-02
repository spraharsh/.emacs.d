;;; agenda-desktop-design-test.el --- Planner rendering check -*- lexical-binding: t -*-
;; Run: emacs -Q --batch -l ~/.emacs.d/test/agenda-desktop-design-test.el -f ert-run-tests-batch-and-exit
(require 'ert)
(load (expand-file-name "../config/agenda-desktop-init.el"
                        (file-name-directory load-file-name)) nil t)

(ert-deftest desktop-design-keeps-date-and-task-markers ()
  (dolist (example '(((9 28 2026) (10 4 2026) "Week 40, 28 Sep – 4 Oct 2026")
                     ((12 28 2026) (1 3 2027) "Week 53, 28 Dec 2026 – 3 Jan 2027")
                     ((12 30 2024) (1 5 2025) "Week 1, 30 Dec 2024 – 5 Jan 2025")))
    (with-temp-buffer
      (insert "Old agenda title\n")
      (dolist (date (list (nth 0 example) (nth 1 example)))
        (insert (propertize "Date\n" 'org-agenda-date-header t
                            'day (calendar-absolute-from-gregorian date))))
      (praharsh-agenda-desktop-style-buffer)
      (goto-char (point-min))
      (should (get-text-property (point) 'agenda-desktop-open))
      (should (= (plist-get (get-text-property (point) 'face) :height) 1.75))
      (forward-line 1)
      (should (equal (buffer-substring-no-properties (point) (line-end-position))
                     (nth 2 example)))
      (forward-line 1)
      (should (= (org-get-at-bol 'day)
                 (calendar-absolute-from-gregorian (car example))))))
  (with-temp-buffer
    (insert "Old agenda title\n")
    (insert (propertize "Date\n" 'org-agenda-date-header t 'day (org-today)))
    (let ((marker (point-marker)))
      (dolist (leader '("In 1 days " "1 days ago " "In 11 days " "In 21 days "))
        (let ((beginning (point)))
          (insert "  " leader (propertize "TODO Keep 1 days in task title" 'org-heading t) "\n")
          (add-text-properties beginning (point)
                               (list 'org-hd-marker marker 'type "deadline" 'day (org-today)))))
      (praharsh-agenda-desktop-style-buffer)
      (goto-char (point-min))
      (should (search-forward "Today" nil t))
      (should-not (search-forward "TODAY" nil t))
      (dolist (leader '("In 1 day " "1 day ago " "In 11 days " "In 21 days "))
        (forward-line 1)
        (should (looking-at (regexp-quote (concat "  " leader "TODO Keep 1 days in task title"))))
        (should (eq (org-get-at-bol 'org-hd-marker) marker))
        (should (equal (org-get-at-bol 'type) "deadline"))
        (should (= (org-get-at-bol 'day) (org-today)))))))

(ert-deftest desktop-design-sizes-for-the-actual-font-cells ()
  (dolist (example '((8 20 488 900) (11 23 484 897) (17 31 476 899)))
    ;; Batch frames have no graphical font metrics or pixel resize support.
    (cl-letf (((symbol-function 'frame-char-width) (lambda (&rest _) (nth 0 example)))
              ((symbol-function 'frame-char-height) (lambda (&rest _) (nth 1 example)))
              ((symbol-function 'set-frame-size)
               (lambda (_ width height pixelwise)
                 (should pixelwise)
                 (should (= width (nth 2 example)))
                 (should (= height (nth 3 example)))
                 (should (<= (+ width 48) 538))
                 (should (<= (+ height 48) 950)))))
      (praharsh-agenda-desktop-size-frame))))

(ert-deftest desktop-design-renders-native-deadline-leaders ()
  (let* ((file (make-temp-file "desktop-deadline-" nil ".org"))
         (org-agenda-files (list file))
         (org-agenda-span 'week)
         (text (mapconcat
                (lambda (offset)
                  (format "* TODO Deadline %s\nDEADLINE: <%s>\n" offset
                          (format-time-string "%Y-%m-%d %a"
                                              (time-add (current-time) (days-to-time offset)))))
                '(-1 0 1) "")))
    (unwind-protect
        (progn
          (with-temp-file file (insert text))
          (with-current-buffer (praharsh-agenda-desktop-build)
            (dolist (leader '("1 day ago " "Deadline " "In 1 day "))
              (should (string-match-p (regexp-quote leader) (buffer-string)))))
          (with-temp-buffer
            (insert-file-contents file)
            (should (equal text (buffer-string)))))
      (when-let* ((buffer (get-file-buffer file))) (kill-buffer buffer))
      (delete-file file))))

;;; agenda-desktop-design-test.el ends here
