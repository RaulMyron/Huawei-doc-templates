#!/usr/bin/env bash
# =====================================================================
#  install.sh — one-command setup for Huawei Document Templates
#  Installs XeLaTeX, LaTeX packages, latexmk, fallback fonts,
#  the opencode skill, and the VS Code LaTeX Workshop extension.
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
    fonts-cascadia-code \
    poppler-utils \
    2>&1 | tail -5

info "TeX Live packages installed"

# ---- Install HarmonyOS Sans font -----------------------------------
step "Installing HarmonyOS Sans font"

HARMONYOS_DEB_URL="https://github.com/zhiyuan1i/fonts-harmonyos-sans-cn/releases/download/v1.0.0/harmonyos_sans.deb"
HARMONYOS_DEB="/tmp/harmonyos_sans.deb"

if fc-list | grep -q "HarmonyOS Sans"; then
    info "HarmonyOS Sans: already installed"
else
    if wget -q "$HARMONYOS_DEB_URL" -O "$HARMONYOS_DEB"; then
        $SUDO apt install -y "$HARMONYOS_DEB" 2>&1 | tail -3
        rm -f "$HARMONYOS_DEB"
        info "HarmonyOS Sans: installed"
    else
        warn "Failed to download HarmonyOS Sans — using fallback fonts"
        echo "  Download manually from: $HARMONYOS_DEB_URL"
    fi
fi

# ---- Update font cache ---------------------------------------------
step "Updating font cache"
fc-cache -f
info "Font cache updated"

# ---- Verify toolchain ----------------------------------------------
step "Verifying toolchain"

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

# Check fonts
if fc-list | grep -q "HarmonyOS Sans"; then
    info "HarmonyOS Sans: available (body text)"
else
    warn "HarmonyOS Sans not found — body text will fall back to Liberation Sans"
fi
if fc-list | grep -q "Liberation Sans"; then
    info "Liberation Sans: available (body text fallback)"
else
    warn "Liberation Sans not found — body text will fall back to Arial"
fi
if fc-list | grep -q "Cascadia Code"; then
    info "Cascadia Code: available (code font)"
else
    warn "Cascadia Code not found — code font will fall back to Consolas or DejaVu Sans Mono"
fi
if fc-list | grep -q "DejaVu Sans Mono"; then
    info "DejaVu Sans Mono: available (code font fallback)"
else
    warn "DejaVu Sans Mono not found — code font may not render correctly"
fi

# ---- Install opencode skills ---------------------------------------
step "Installing opencode skills"

GLOBAL_SKILLS_DIR="$HOME/.config/opencode/skills"
SKILL_COUNT=0

for skill_file in "$SCRIPT_DIR"/templates/*/SKILL.md; do
    if [[ -f "$skill_file" ]]; then
        skill_name=$(awk '/^name:/{print $2}' "$skill_file")
        skill_dst_dir="$GLOBAL_SKILLS_DIR/$skill_name"
        mkdir -p "$skill_dst_dir"
        cp "$skill_file" "$skill_dst_dir/SKILL.md"
        info "Skill '$skill_name': installed to $skill_dst_dir/SKILL.md"
        SKILL_COUNT=$((SKILL_COUNT + 1))
    fi
done

if [[ $SKILL_COUNT -eq 0 ]]; then
    warn "No skills found in templates/*/SKILL.md — skipping"
else
    echo "  $SKILL_COUNT skill(s) installed — restart opencode to discover them"
    echo "  Project-level discovery also works via opencode.json (skills.paths)"
fi

# ---- Configure VS Code (user-level) ---------------------------------
step "Configuring VS Code (user-level)"

VSCODE_USER_DIR="$HOME/.config/Code/User"
VSCODE_USER_SETTINGS="$VSCODE_USER_DIR/settings.json"
mkdir -p "$VSCODE_USER_DIR"

# Merge LaTeX Workshop settings into the user's settings.json idempotently
python3 - "$VSCODE_USER_SETTINGS" <<'PYEOF'
import json, sys, os

settings_path = sys.argv[1]

# Load existing settings (or empty dict)
if os.path.exists(settings_path):
    with open(settings_path, "r") as f:
        try:
            settings = json.load(f)
        except json.JSONDecodeError:
            settings = {}
else:
    settings = {}

# LaTeX Workshop settings for XeLaTeX via latexmk
latex_settings = {
    "latex-workshop.latex.recipe.default": "latexmk",
    "latex-workshop.latex.recipes": [
        {"name": "latexmk", "tools": ["latexmk"]},
        {"name": "xelatex×2", "tools": ["xelatex", "xelatex"]},
        {"name": "xelatex", "tools": ["xelatex"]}
    ],
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": ["-cd", "-xelatex", "-interaction=nonstopmode", "%DOC%"]
        },
        {
            "name": "xelatex",
            "command": "xelatex",
            "args": ["-synctex=1", "-interaction=nonstopmode",
                     "-file-line-error", "%DOC%"]
        }
    ],
    "latex-workshop.view.pdf.viewer": "tab",
    "latex-workshop.latex.autoBuild.run": "onSave"
}

# Merge (only update keys that differ or are missing)
changed = False
for key, value in latex_settings.items():
    if key not in settings or settings[key] != value:
        settings[key] = value
        changed = True

if changed:
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    print(f"  ✓ Updated {settings_path}")
else:
    print(f"  ✓ {settings_path} already configured")
PYEOF

# Install LaTeX Workshop extension if VS Code CLI is available
if command -v code &>/dev/null; then
    info "VS Code CLI detected: $(command -v code)"

    if code --install-extension James-Yu.latex-workshop --force 2>/dev/null; then
        info "Extension installed: LaTeX Workshop (James-Yu.latex-workshop)"
    else
        warn "Failed to install LaTeX Workshop extension"
    fi

    # Optional: LTeX for spell/grammar checking
    if code --install-extension valentjn.vscode-ltex --force 2>/dev/null; then
        info "Extension installed: LTeX (valentjn.vscode-ltex)"
    else
        warn "Failed to install LTeX extension (optional — spell/grammar checking)"
    fi
else
    warn "VS Code CLI (code) not found — extensions not installed"
    echo "  Settings were still written to $VSCODE_USER_SETTINGS"
    echo "  To install extensions manually:"
    echo "    1. Install VS Code: https://code.visualstudio.com/"
    echo "    2. Install LaTeX Workshop extension from the marketplace"
fi

# ---- Test compile --------------------------------------------------
step "Test compilation"

PT_DIR="$SCRIPT_DIR/templates/guide/samples/pt"
EN_DIR="$SCRIPT_DIR/templates/guide/samples/en"

if [[ -f "$PT_DIR/main.tex" ]]; then
    cd "$PT_DIR"
    latexmk -C main.tex 2>/dev/null
    if latexmk main.tex 2>/dev/null; then
        PAGES=$(pdfinfo main.pdf 2>/dev/null | grep "^Pages:" | awk '{print $2}')
        info "Portuguese sample compiled successfully (${PAGES:-?} pages)"
        latexmk -C main.tex 2>/dev/null
    else
        warn "Portuguese sample compile failed — check templates/guide/samples/pt/main.log"
    fi
else
    warn "PT sample not found at $PT_DIR — skipping"
fi

if [[ -f "$EN_DIR/main.tex" ]]; then
    cd "$EN_DIR"
    latexmk -C main.tex 2>/dev/null
    if latexmk main.tex 2>/dev/null; then
        PAGES=$(pdfinfo main.pdf 2>/dev/null | grep "^Pages:" | awk '{print $2}')
        info "English sample compiled successfully (${PAGES:-?} pages)"
        latexmk -C main.tex 2>/dev/null
    else
        warn "English sample compile failed — check templates/guide/samples/en/main.log"
    fi
else
    warn "EN sample not found at $EN_DIR — skipping"
fi

# ---- Done ----------------------------------------------------------
step "Setup complete!"

echo ""
echo -e "${BOLD}What was installed:${RESET}"
echo "  • XeLaTeX (TeX Live)    — LaTeX engine with system font support"
echo "  • latexmk                — build automation (uses .latexmkrc → xelatex)"
echo "  • LaTeX packages         — titlesec, tocloft, enumitem, tcolorbox, babel, etc."
echo "  • HarmonyOS Sans         — Huawei brand font (free commercial use)"
echo "  • Cascadia Code          — code font (open source, Microsoft)"
echo "  • Liberation Sans        — fallback for HarmonyOS Sans"
echo "  • opencode skill         — /skill huawei-template-guide (project + global)"
echo "  • VS Code LaTeX Workshop — XeLaTeX recipes, PDF preview, SyncTeX"
echo ""
echo -e "${BOLD}Next steps:${RESET}"
echo "  1. Open this project in opencode"
echo "  2. Run ${BOLD}/skill huawei-template-guide${RESET} to create a new guide document"
echo "  3. Or open in VS Code and save samples/pt/main.tex — PDF preview appears automatically"
echo "  4. Or compile manually:"
echo "       cd templates/guide/samples/pt && latexmk main.tex   # Portuguese"
echo "       cd templates/guide/samples/en && latexmk main.tex   # English"
echo ""
echo -e "${BOLD}Optional (for full font fidelity):${RESET}"
echo "  • Consolas is optional — Cascadia Code is the default code font"
echo ""
