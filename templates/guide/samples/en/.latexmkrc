# latexmkrc — use XeLaTeX by default (the class loads fontspec, so pdflatex won't work)
# TEXINPUTS includes ../../ so guide.cls and assets/ are found from the template root
$ENV{TEXINPUTS} = "../../:" . ($ENV{TEXINPUTS} || "");
$ENV{TZ} = "America/Sao_Paulo";  # default TZ (GMT-3); projects can override
$pdf_mode = 5;    # 5 = xelatex
$xelatex = 'xelatex -interaction=nonstopmode %O %S';
