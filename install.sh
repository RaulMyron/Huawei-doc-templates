#!/usr/bin/env bash
# =====================================================================
#  install.sh — one-command setup for Huawei Document Templates
#  Installs XeLaTeX, LaTeX packages, latexmk, and fallback fonts.
#  Tested on Ubuntu 22.04 / 24.04 (WSL and native).
# =====================================================================
set -euo pipefail

BOLD="\033[1m"
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

info()  { echo -e "${GREEN}✓${RESET} $1"; }
warn()  { echo -e "${YELLOW}⚠${RESET}  $1"; }
error() { echo -e "${RED}✗${RESET} $1"; }
step()  { echo -e "\n${BOLD}=== $1 ===${RESET}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---- Pre-flight checks ---------------------------------------------
step "Pre-flight checks"

if [[ $EUID -eq 0 ]]; then
    warn "Running as root — sudo steps will be skipped."
    SUDO=""
else
    SUDO="sudo"
fi

if ! command -v apt-get &>/dev/null; then
    error "apt-get not found. This script targets Ubuntu/Debian."
    echo ""
    echo "For Fedora/RHEL, install manually:"
    echo "  sudo dnf install texlive-collection-xetex texlive-collection-latexextra \\"
    echo "                    texlive-collection-lang-portuguese latexmk \\"
    echo "                    liberation-sans-fonts"
    exit 1
fi
info "apt-get detected"

# ---- Install TeX Live packages -------------------------------------
step "Installing TeX Live packages (this may take a few minutes)"

$SUDO apt-get update -qq
$SUDO apt-get install -y \
    texlive-xetex \
    texlive-latex-extra \
    texlive-lang-portuguese \
    latexmk \
    fonts-liberation \
    2>&1 | tail -5

info "TeX Live packages installed"

# ---- Update font cache ---------------------------------------------
step "Updating font cache"
fc-cache -f
info "Font cache updated"

# ---- Verify toolchain ----------------------------------------------
step "Verifying installation"

verify() {
    if command -v "$1" &>/dev/null; then
        info "$1: $($1 --version 2>/dev/null | head -1)"
    else
        error "$1 not found after installation"
        return 1
    fi
}

verify xelatex
verify latexmk

# Check fallback fonts
if fc-list | grep -q "Liberation Sans"; then
    info "Liberation Sans: available (body text fallback)"
else
    warn "Liberation Sans not found — body text will fall back to Arial"
fi
if fc-list | grep -q "DejaVu Sans Mono"; then
    info "DejaVu Sans Mono: available (code font fallback)"
else
    warn "DejaVu Sans Mono not found — code font may not render correctly"
fi

# ---- Test compile --------------------------------------------------
step "Test compilation"

LABGUIDE_DIR="$SCRIPT_DIR/templates/labguide"
if [[ -f "$LABGUIDE_DIR/main.tex" ]]; then
    cd "$LABGUIDE_DIR"
    latexmk -C main.tex 2>/dev/null
    if latexmk main.tex 2>/dev/null; then
        PAGES=$(pdfinfo main.pdf 2>/dev/null | grep "^Pages:" | awk '{print $2}')
        info "Portuguese sample compiled successfully (${PAGES:-?} pages)"
        latexmk -C main.tex 2>/dev/null
    else
        warn "Portuguese sample compile failed — check templates/labguide/main.log"
    fi

    if [[ -f "main_en.tex" ]]; then
        latexmk -C main_en.tex 2>/dev/null
        if latexmk main_en.tex 2>/dev/null; then
            PAGES=$(pdfinfo main_en.pdf 2>/dev/null | grep "^Pages:" | awk '{print $2}')
            info "English sample compiled successfully (${PAGES:-?} pages)"
            latexmk -C main_en.tex 2>/dev/null
        else
            warn "English sample compile failed — check templates/labguide/main_en.log"
        fi
    fi
else
    warn "Template not found at $LABGUIDE_DIR — skipping test compile"
fi

# ---- Done ----------------------------------------------------------
step "Setup complete!"

echo ""
echo -e "${BOLD}What was installed:${RESET}"
echo "  • XeLaTeX (TeX Live) — LaTeX engine with system font support"
echo "  • latexmk             — build automation (uses .latexmkrc → xelatex)"
echo "  • LaTeX packages      — titlesec, tocloft, enumitem, tcolorbox, babel, etc."
echo "  • Liberation Sans     — fallback for Huawei Sans (proprietary)"
echo ""
echo -e "${BOLD}Next steps:${RESET}"
echo "  1. Open this project in opencode"
echo "  2. Run ${BOLD}/skill labguide${RESET} to create a new lab guide document"
echo "  3. Or compile the samples manually:"
echo "       cd templates/labguide && latexmk main.tex      # Portuguese"
echo "       cd templates/labguide && latexmk main_en.tex   # English"
echo ""
echo -e "${BOLD}Optional (for full font fidelity):${RESET}"
echo "  • Install Huawei Sans (proprietary — obtain from Huawei)"
echo "  • Install Consolas (Microsoft font — copy from a licensed Windows install)"
echo ""
