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
                       ("f" "for $1 in $2:\n    $0" "for" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/forloop.yasnippet" nil nil)
                       ("example.yasnippet" "" "example.yasnippet" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/example.yasnippet" nil nil)
                       ("defg" "def ${1:name}($2):\n    \\\"\\\"\\\"$3\n    ${2:$(python-args-to-google-docstring yas-text t)}\n    ${5:Returns:\n        $6\n}\n    \\\"\\\"\\\"\n    ${0:$$(let ((beg yas-snippet-beg)\n                (end yas-snippet-end))\n        (yas-expand-snippet\n          (buffer-substring-no-properties beg end) beg end\n              (quote ((yas-indent-line nil) (yas-wrap-around-region nil))))\n            (delete-trailing-whitespace beg (- end 1)))}" "Python Google style Docstring" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/defg.yasnippet" nil nil)
                       ("de" "def ${1:name}($2):\n    \\\"\\\"\\\"$3\n    ${2:$(python-args-to-google-docstring yas-text t)}\n    ${5:Returns:\n        $6\n}\n    \\\"\\\"\\\"\n    ${0:$$(let ((beg yas-snippet-beg)\n                (end yas-snippet-end))\n        (yas-expand-snippet\n          (buffer-substring-no-properties beg end) beg end\n              (quote ((yas-indent-line nil) (yas-wrap-around-region nil))))\n            (delete-trailing-whitespace beg (- end 1)))}" "Python Google style Docstring" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/def.yasnippet" nil nil)
                       ("jsoajn" "'$1'$0" "'" nil nil nil "/home/praharsh/.emacs.d/snippets/python-mode/colons.py" "' '" nil)))


;;; Do not edit! File generated at Tue Dec  3 15:17:41 2019
