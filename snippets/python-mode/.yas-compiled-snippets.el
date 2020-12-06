;;; Compiled snippets and support files for `python-mode'
;;; contents of the .yas-setup.el support file:
;;;
(defun python-args-to-google-docstring (text &optional make-fields)
  "Return a reST docstring format for the python arguments in yas-text."
  (let* ((indent (concat "\n" (make-string (current-column) 32)))
         (args (python-split-args text))
     (nr 0)
         (formatted-args
      (mapconcat
       (lambda (x)
         (concat "   " (nth 0 x)
             (if make-fields (format " ${%d:arg%d}" (cl-incf nr) nr))
             (if (nth 1 x) (concat " \(default " (nth 1 x) "\)"))))
       args
       indent)))
    (unless (string= formatted-args "")
      (concat
       (mapconcat 'identity
          (list "" "Args:" formatted-args)
          indent)
       "\n"))))
;;; Snippet definitions:
;;;
(yas-define-snippets 'python-mode
                     '(("lp" "print($1, \"$1\")" "printcheck" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/print.yasnippet" "' p" nil)
                       ("prm"
                        (progn
                          (flet
                              ((parse-args
                                (count tmp-buf)
                                (while
                                    (and
                                     (< count 5)
                                     (= 1
                                        (call-process-shell-command
                                         (format
                                          (concat "python << ___EOF___\n" "%s\n" " pass\n" "print(%s.__code__.co_varnames)\n" "___EOF___")
                                          (replace-regexp-in-string "^ *def" "def"
                                                                    (buffer-substring-no-properties
                                                                     (line-beginning-position)
                                                                     (line-end-position
                                                                      (incf count))))
                                          (replace-regexp-in-string "^ *def *\\(.*?\\)(.*$" "\\1"
                                                                    (buffer-substring-no-properties
                                                                     (line-beginning-position)
                                                                     (line-end-position))))
                                         nil
                                         (list tmp-buf nil))))))
                               (form-template
                                (arg-list template)
                                (let
                                    ((count 0))
                                  (dolist
                                      (narg arg-list template)
                                    (setq template
                                          (format
                                           (concat "%s${%d:%s: ${%d:type}\n"
                                                   (make-string python-indent 32)
                                                   "${%d:description}\n}")
                                           template
                                           (incf count)
                                           narg
                                           (incf count)
                                           (incf count)))))
                                (replace-regexp-in-string "}\\n}$" "}}" template))
                               (get-word-from-nline
                                (n)
                                (replace-regexp-in-string "[ 	-]*" ""
                                                          (buffer-substring-no-properties
                                                           (line-beginning-position n)
                                                           (line-end-position n)))))
                            (if
                                (and
                                 (equal ""
                                        (get-word-from-nline 0))
                                 (equal "parameters"
                                        (downcase
                                         (get-word-from-nline -1))))
                                (delete-region
                                 (line-beginning-position -1)
                                 (line-beginning-position 1)))
                            (let
                                ((indent
                                  (python-indent-calculate-indentation))
                                 (match)
                                 (template "Parameters\n----------\n")
                                 (tmp-buf "*tmp sni-param*"))
                              (save-excursion
                                (while
                                    (and
                                     (re-search-backward "^[ 	]*\\(def\\|class\\)" nil t)
                                     (setq match
                                           (match-string-no-properties 1))
                                     (re-search-forward "[ 	]*[dc]" nil t)
                                     (not
                                      (=
                                       (-
                                        (point)
                                        (line-beginning-position)
                                        1)
                                       (- indent python-indent)))))
                                (cond
                                 ((equal match "def")
                                  (parse-args 0 tmp-buf)
                                  (setq template
                                        (form-template
                                         (split-string
                                          (with-current-buffer tmp-buf
                                            (buffer-string))
                                          "[()', \n]+" t)
                                         template))
                                  (kill-buffer tmp-buf))
                                 ((equal match "class")
                                  (while
                                      (and
                                       (re-search-forward "^[ 	]+def +__init__" nil t)
                                       (not
                                        (=
                                         (python-indent-calculate-levels)
                                         indent))))
                                  (parse-args 0 tmp-buf)
                                  (setq template
                                        (form-template
                                         (cdr
                                          (split-string
                                           (with-current-buffer tmp-buf
                                             (buffer-string))
                                           "[()', \n]+" t))
                                         template))
                                  (kill-buffer tmp-buf))))
                              (yas-expand-snippet template nil nil
                                                  '((yas-indent-line 'fixed))))))
                        "parameters" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/parameters.yasnippet" nil nil)
                       ("parameters"
                        (progn
                          (flet
                              ((parse-args
                                (count tmp-buf)
                                (while
                                    (and
                                     (< count 5)
                                     (= 1
                                        (call-process-shell-command
                                         (format
                                          (concat "python << ___EOF___\n" "%s\n" " pass\n" "print(%s.__code__.co_varnames)\n" "___EOF___")
                                          (replace-regexp-in-string "^ *def" "def"
                                                                    (buffer-substring-no-properties
                                                                     (line-beginning-position)
                                                                     (line-end-position
                                                                      (incf count))))
                                          (replace-regexp-in-string "^ *def *\\(.*?\\)(.*$" "\\1"
                                                                    (buffer-substring-no-properties
                                                                     (line-beginning-position)
                                                                     (line-end-position))))
                                         nil
                                         (list tmp-buf nil))))))
                               (form-template
                                (arg-list template)
                                (let
                                    ((count 0))
                                  (dolist
                                      (narg arg-list template)
                                    (setq template
                                          (format
                                           (concat "%s${%d:%s: ${%d:type}\n"
                                                   (make-string python-indent 32)
                                                   "${%d:description}\n}")
                                           template
                                           (incf count)
                                           narg
                                           (incf count)
                                           (incf count)))))
                                (replace-regexp-in-string "}\\n}$" "}}" template))
                               (get-word-from-nline
                                (n)
                                (replace-regexp-in-string "[ 	-]*" ""
                                                          (buffer-substring-no-properties
                                                           (line-beginning-position n)
                                                           (line-end-position n)))))
                            (if
                                (and
                                 (equal ""
                                        (get-word-from-nline 0))
                                 (equal "parameters"
                                        (downcase
                                         (get-word-from-nline -1))))
                                (delete-region
                                 (line-beginning-position -1)
                                 (line-beginning-position 1)))
                            (let
                                ((indent
                                  (python-indent-calculate-indentation))
                                 (match)
                                 (template "Parameters\n----------\n")
                                 (tmp-buf "*tmp sni-param*"))
                              (save-excursion
                                (while
                                    (and
                                     (re-search-backward "^[ 	]*\\(def\\|class\\)" nil t)
                                     (setq match
                                           (match-string-no-properties 1))
                                     (re-search-forward "[ 	]*[dc]" nil t)
                                     (not
                                      (=
                                       (-
                                        (point)
                                        (line-beginning-position)
                                        1)
                                       (- indent python-indent)))))
                                (cond
                                 ((equal match "def")
                                  (parse-args 0 tmp-buf)
                                  (setq template
                                        (form-template
                                         (split-string
                                          (with-current-buffer tmp-buf
                                            (buffer-string))
                                          "[()', \n]+" t)
                                         template))
                                  (kill-buffer tmp-buf))
                                 ((equal match "class")
                                  (while
                                      (and
                                       (re-search-forward "^[ 	]+def +__init__" nil t)
                                       (not
                                        (=
                                         (python-indent-calculate-levels)
                                         indent))))
                                  (parse-args 0 tmp-buf)
                                  (setq template
                                        (form-template
                                         (cdr
                                          (split-string
                                           (with-current-buffer tmp-buf
                                             (buffer-string))
                                           "[()', \n]+" t))
                                         template))
                                  (kill-buffer tmp-buf))))
                              (yas-expand-snippet template nil nil
                                                  '((yas-indent-line 'fixed))))))
                        "parameters" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/parameters" nil nil)
                       ("npdef" "def ${1:function}(${2:args}):\n    \"\"\"${3:short description}\n\n    $0\n\n    ${4:Parameters\n    ----------\n    ${5:Please press the tab key twice$(replace-regexp-in-string\n                                           \"Please press the tab key twice\" \"prm\" yas-text)}\n    }\"\"\"" "npdef" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/npdef.yasnippet" nil nil)
                       ("f" "for $1 in $2:\n    $0" "for" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/forloop.yasnippet" nil nil)
                       ("example.yasnippet" "" "example.yasnippet" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/example.yasnippet" nil nil)
                       ("dret" "Returns\n----------\n" "document return" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/dret.yasnippet" nil nil)
                       ("defg" "def ${1:name}($2):\n    \\\"\\\"\\\"$3\n    ${2:$(python-args-to-google-docstring yas-text t)}\n    ${5:Returns:\n        $6\n}\n    \\\"\\\"\\\"\n    ${0:$$(let ((beg yas-snippet-beg)\n                (end yas-snippet-end))\n        (yas-expand-snippet\n          (buffer-substring-no-properties beg end) beg end\n              (quote ((yas-indent-line nil) (yas-wrap-around-region nil))))\n            (delete-trailing-whitespace beg (- end 1)))}" "Python Google style Docstring" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/defg.yasnippet" nil nil)
                       ("de" "def ${1:name}($2):\n    \\\"\\\"\\\"$3\n    ${2:$(python-args-to-google-docstring yas-text t)}\n    ${5:Returns:\n        $6\n}\n    \\\"\\\"\\\"\n    ${0:$$(let ((beg yas-snippet-beg)\n                (end yas-snippet-end))\n        (yas-expand-snippet\n          (buffer-substring-no-properties beg end) beg end\n              (quote ((yas-indent-line nil) (yas-wrap-around-region nil))))\n            (delete-trailing-whitespace beg (- end 1)))}" "Python Google style Docstring" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/def.yasnippet" nil nil)
                       ("jsoajn" "'$1'$0" "'" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/colons.py" "' '" nil)))


;;; Do not edit! File generated at Sat Nov 28 18:18:29 2020
