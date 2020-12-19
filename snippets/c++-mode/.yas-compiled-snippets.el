;;; Compiled snippets and support files for `c++-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'c++-mode
                     '(("set" "inline void set_${1:variable}(double $1_in) { $1 = $1_in; }" "set" nil nil nil "/home/praharsh/.emacs.d/snippets/c++-mode/setvar.yasnippet" nil nil)
                       ("get" "inline ${2:type} get_${1:variable}() {return $1;}\n$0" "get" nil nil nil "/home/praharsh/.emacs.d/snippets/c++-mode/getvar.yasnippet" nil nil)
                       ("d" "double $0" "double" nil nil nil "/home/praharsh/.emacs.d/snippets/c++-mode/double.yasnippet" nil nil)
                       ("cb" "/* -----------------------------------------------------------------------------\n * ${1:comment}\n * ---------------------------------------------------------------------------*/\n$0" "cb" nil nil nil "/home/praharsh/.emacs.d/snippets/c++-mode/commentblock.yasnippet" nil nil)))


;;; Do not edit! File generated at Thu Dec 17 19:04:04 2020
