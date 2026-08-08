# Makefile — build convenience for Huawei Document Templates
# Usage:
#   make            — compile all documents (samples + examples)
#   make samples    — compile PT and EN samples only
#   make examples   — compile setup-guide only
#   make clean      — remove all build artifacts
#   make clean-samples / clean-examples — clean specific targets

.PHONY: all samples examples clean clean-samples clean-examples

PT_DIR   = examples/guide/pt
EN_DIR   = examples/guide/en
SG_DIR   = examples/setup-guide

all: samples examples

samples:
	cd $(PT_DIR) && latexmk main.tex
	cd $(EN_DIR) && latexmk main.tex

examples:
	cd $(SG_DIR) && latexmk setup-guide.tex
	cp $(SG_DIR)/setup-guide.pdf setup-guide.pdf

clean: clean-samples clean-examples

clean-samples:
	cd $(PT_DIR) && latexmk -C main.tex
	cd $(EN_DIR) && latexmk -C main.tex

clean-examples:
	cd $(SG_DIR) && latexmk -C setup-guide.tex
	rm -f setup-guide.pdf
