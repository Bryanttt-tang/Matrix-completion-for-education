(TeX-add-style-hook
 "exercise9_upload"
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
    "enumerate"
    "geometry"
    "multicol")
   (LaTeX-add-labels
    "eq:1"
    "pt1"
    "eq:2"
    "eq:3"
    "eq:4"
    "pt2"
    "eq:5"
    "eq:6"
    "pt.sec"))
 :latex)

