# latexmkrc — project folder, template at ../templates/guide/
$ENV{TEXINPUTS} = "../templates/guide/:" . ($ENV{TEXINPUTS} || "");
$pdf_mode = 5;    # 5 = xelatex
$xelatex = 'xelatex -interaction=nonstopmode %O %S';
