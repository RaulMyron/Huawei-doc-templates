# Makefile — build convenience for Huawei Document Templates
# Usage:
#   make                 — compile all documents (all samples + examples)
#   make samples         — compile LaTeX PT and EN samples only
#   make examples        — compile setup-guide only
#   make pt / en         — compile specific LaTeX sample
#   make ppt-samples     — generate PPT sample decks (PT + EN)
#   make technical-samples — generate technical report samples (PT + EN, DOCX)
#   make setup-guide     — compile setup guide only
#   make project DIR=examples/my-guide — compile a specific LaTeX project
#   make slides DIR=examples/my-slides  — generate PPT deck (runs generate.py)
#   make technical DIR=examples/my-report — generate technical report (runs generate.py)
#   make clean           — remove all build artifacts
#   make clean-project DIR=examples/my-guide — clean a specific project
#
# Note: `make docx` / `make docx-samples` are kept as backward-compatibility
# aliases for `make technical` / `make technical-samples`.

.PHONY: all samples examples pt en setup-guide project slides technical
.PHONY: ppt-samples ppt-pt ppt-en technical-samples technical-pt technical-en
.PHONY: docx docx-samples
.PHONY: clean clean-samples clean-examples clean-pt clean-en clean-setup-guide clean-project

PT_DIR        = examples/guide/pt
EN_DIR        = examples/guide/en
SG_DIR        = examples/setup-guide
PPT_PT        = examples/ppt/pt
PPT_EN        = examples/ppt/en
TECHNICAL_PT  = examples/technical/pt
TECHNICAL_EN  = examples/technical/en

all: samples examples ppt-samples technical-samples

samples: pt en

examples: setup-guide

ppt-samples: ppt-pt ppt-en

technical-samples: technical-pt technical-en

# ── Per-project targets ──
pt:
	cd $(PT_DIR) && latexmk main.tex

en:
	cd $(EN_DIR) && latexmk main.tex

setup-guide:
	cd $(SG_DIR) && latexmk setup-guide.tex
	cp $(SG_DIR)/setup-guide.pdf setup-guide.pdf

# ── PPT sample targets ──
ppt-pt:
	cd $(PPT_PT) && python3 generate.py

ppt-en:
	cd $(PPT_EN) && python3 generate.py

# ── Technical report sample targets ──
technical-pt:
	cd $(TECHNICAL_PT) && python3 generate.py

technical-en:
	cd $(TECHNICAL_EN) && python3 generate.py

# ── Generic project target (auto-detects the .tex file) ──
# Usage: make project DIR=examples/my-guide
#        make project DIR=examples/my-guide FILE=custom.tex
project:
	@if [ -z "$(DIR)" ]; then echo "Usage: make project DIR=<path> [FILE=<name>.tex]"; exit 1; fi
	@if [ -z "$(FILE)" ]; then \
		TEX=$$(ls $(DIR)/*.tex 2>/dev/null | head -1); \
		if [ -z "$$TEX" ]; then echo "No .tex file found in $(DIR)/"; exit 1; fi; \
		echo "Compiling $$TEX"; \
		cd $(DIR) && latexmk $$(basename $$TEX); \
	else \
		echo "Compiling $(DIR)/$(FILE)"; \
		cd $(DIR) && latexmk $(FILE); \
	fi

# ── Generic slides target (runs generate.py) ──
# Usage: make slides DIR=documents/my-project/slides
slides:
	@if [ -z "$(DIR)" ]; then echo "Usage: make slides DIR=<path-with-generate.py>"; exit 1; fi
	@cd $(DIR) && python3 generate.py

# ── Generic technical report target (runs generate.py) ──
# Usage: make technical DIR=documents/my-project/report
technical:
	@if [ -z "$(DIR)" ]; then echo "Usage: make technical DIR=<path-with-generate.py>"; exit 1; fi
	@cd $(DIR) && python3 generate.py

# ── Backward-compatibility aliases (docx → technical) ──
docx: technical
docx-samples: technical-samples

# ── Clean targets ──
clean: clean-samples clean-examples

clean-samples: clean-pt clean-en

clean-examples: clean-setup-guide

clean-pt:
	cd $(PT_DIR) && latexmk -C main.tex

clean-en:
	cd $(EN_DIR) && latexmk -C main.tex

clean-setup-guide:
	cd $(SG_DIR) && latexmk -C setup-guide.tex
	rm -f setup-guide.pdf

clean-project:
	@if [ -z "$(DIR)" ]; then echo "Usage: make clean-project DIR=<path> [FILE=<name>.tex]"; exit 1; fi
	@if [ -z "$(FILE)" ]; then \
		TEX=$$(ls $(DIR)/*.tex 2>/dev/null | head -1); \
		if [ -z "$$TEX" ]; then echo "No .tex file found in $(DIR)/"; exit 1; fi; \
		cd $(DIR) && latexmk -C $$(basename $$TEX); \
	else \
		cd $(DIR) && latexmk -C $(FILE); \
	fi
