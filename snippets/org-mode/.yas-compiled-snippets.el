;;; Compiled snippets and support files for `org-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'org-mode
                     '(("sb" "#+NAME: ${1:name}\n#+BEGIN_SRC ${2:language}\n  $3\n#+END_SRC" "#+srcname:..#+begin_src...#+end_src"
                        (or
                         (=
                          (current-column)
                          2)
                         (=
                          (current-column)
                          0))
                        nil nil "/home/praharsh/.emacs.d/snippets/org-mode/source.yasnippet" "C-c y s" nil)
                       ("eqn" "# <<$1>>\n\\begin{equation}\n\\label{${1:label$(unless yas/modified-p (reftex-label nil 'dont-insert))}}\n${2: label} ~ ${3: punctuation}\n\\end{equation}\n$0\n" "equation(punctuated)"
                        (or
                         (=
                          (current-column)
                          3)
                         (=
                          (current-column)
                          0))
                        nil nil "/home/praharsh/.emacs.d/snippets/org-mode/eqn.yasnippet" nil nil)
                       ("char" "#+title: ${1:Title}\n#+author: ${2}\n#+PROPERTY: friendcircles ${3}\n#+PROPERTY: interests ${4}\n#+PROPERTY: att-to-me ${5}/10\n#+PROPERTY: prating ${6}/10\n#+PROPERTY: value ${7}/10\n#+PROPERTY: socialintp ${8}/3\n#+TAGS: ${9}\n\n* Background\n${9}\n* Personality\n$0" "character sheet" nil nil nil "/home/praharsh/.emacs.d/snippets/org-mode/charsheet.yasnippet" nil nil)))


;;; Do not edit! File generated at Sat Nov 28 18:18:29 2020
