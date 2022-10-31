(TeX-add-style-hook
 "solution9"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "11pt" "a4paper")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "margin=1in")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art11"
    "amsfonts"
    "amsmath"
    "amssymb"
    "amsthm"
    "mathtools"
    "enumerate"
    "geometry"
    "multicol")
   (LaTeX-add-labels
    "eq:1"))
 :latex)

