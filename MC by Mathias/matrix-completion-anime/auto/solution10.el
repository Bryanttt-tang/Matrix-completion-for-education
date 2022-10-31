(TeX-add-style-hook
 "solution10"
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
    "fig:soln3"
    "fig:rats2"
    "fig:rat3"))
 :latex)

