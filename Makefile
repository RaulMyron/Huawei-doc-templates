# Makefile — build convenience for Huawei Document Templates
# Usage:
#   make            — compile all documents (samples + examples)
#   make samples    — compile PT and EN samples only
#   make examples   — compile setup-guide only
#   make clean      — remove all build artifacts
#   make clean-samples / clean-examples — clean specific targets

.PHONY: all samples examples clean clean-samples clean-examples

PT_DIR   = templates/guide/samples/pt
EN_DIR   = templates/guide/samples/en
SG_DIR   = examples/setup-guide

all: samples examples

samples:
	cd $(PT_DIR) && latexmk main.tex
	cd $(EN_DIR) && latexmk main.tex

examples:
	cd $(SG_DIR) && latexmk setup-guide.tex

clean: clean-samples clean-examples

clean-samples:
	cd $(PT_DIR) && latexmk -C main.tex
	cd $(EN_DIR) && latexmk -C main.tex

clean-examples:
	cd $(SG_DIR) && latexmk -C setup-guide.tex
