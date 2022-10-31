(TeX-add-style-hook
 "exercise11_upload"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "11pt" "a4paper")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "margin=1in")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "url")
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art11"
    "amsfonts"
    "amsmath"
    "amssymb"
    "amsthm"
    "enumerate"
    "geometry"
    "multicol"
    "url")
   (TeX-add-symbols
    "Pokemon")
   (LaTeX-add-labels
    "eq:1"
    "tab:anime"))
 :latex)

