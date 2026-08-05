# latexmkrc — use XeLaTeX by default (the class loads fontspec, so pdflatex won't work)
$pdf_mode = 5;    # 5 = xelatex
$xelatex = 'xelatex -interaction=nonstopmode %O %S';
