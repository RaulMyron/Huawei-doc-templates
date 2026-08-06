#!/usr/bin/env bash
# ─── install.sh — One-command setup for Huawei Document Templates ───────────
#
# Domain:        LaTeX document templates
# Description:   Installs XeLaTeX, LaTeX packages, latexmk, brand fonts
#                (HarmonyOS Sans + Cascadia Code), opencode skill, and
#                VS Code LaTeX Workshop (user-level). Tested on Ubuntu 22.04+
#
# Usage:
#   ./install.sh                # full install (idempotent — safe to re-run)
# ──────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors (TTY-aware) ──
if [ -t 1 ]; then
  C_RESET="\033[0m"  C_BOLD="\033[1m"  C_DIM="\033[2m"
  C_RED="\033[31m"   C_GREEN="\033[32m" C_YELLOW="\033[33m"
  C_BLUE="\033[34m"  C_CYAN="\033[36m"
else
  C_RESET="" C_BOLD="" C_DIM=""
  C_RED="" C_GREEN="" C_YELLOW="" C_BLUE="" C_CYAN=""
fi

# ── Logging helpers ──
log_step()  { echo -e "\n${C_BOLD}${C_CYAN}── $1 ──${C_RESET}"; }
log_desc()  { echo -e "  ${C_DIM}$1${C_RESET}"; }
log_info()  { echo -e "  ${C_GREEN}✓${C_RESET} $1"; }
log_ok()    { echo -e "  ${C_GREEN}✓${C_RESET} $1"; }
log_warn()  { echo -e "  ${C_YELLOW}⚠${C_RESET}  $1"; }
log_error() { echo -e "  ${C_RED}✗${C_RESET} $1"; }
log_done()  { echo -e "  ${C_GREEN}✓${C_RESET} ${C_BOLD}$1${C_RESET}"; }
log_dim()   { echo -e "    ${C_DIM}$1${C_RESET}"; }

# ── Banner ──
_banner_text="Huawei Document Templates — install.sh"
_banner_width=$(( ${#_banner_text} + 4 ))
_banner_border=""
for _i in $(seq 1 $_banner_width); do _banner_border+="═"; done
echo ""
echo -e "${C_BOLD}${C_CYAN}╔${_banner_border}╗${C_RESET}"
echo -e "${C_BOLD}${C_CYAN}║  ${_banner_text}  ║${C_RESET}"
echo -e "${C_BOLD}${C_CYAN}╚${_banner_border}╝${C_RESET}"
echo ""

echo -e "  ${C_BOLD}What:${C_RESET}  LaTeX templates for Huawei Cloud guides (XeLaTeX + latexmk)"
echo ""
echo -e "  ${C_BOLD}Installs:${C_RESET}"
log_dim "• XeLaTeX + latexmk + LaTeX packages"
log_dim "• HarmonyOS Sans (body font, free commercial use)"
log_dim "• Cascadia Code (code font, open source)"
log_dim "• opencode skill (/skill huawei-template-guide)"
log_dim "• VS Code LaTeX Workshop (user-level config)"
echo ""
echo -e "  ${C_BOLD}Prerequisites:${C_RESET}"
log_dim "• Ubuntu 22.04+ (WSL or native)     (required)"
log_dim "• apt-get, sudo                      (required)"
log_dim "• VS Code CLI (code)                 (optional — for extension install)"
echo ""

# ── Pre-flight checks ──
log_step "Pre-flight checks"

if [[ $EUID -eq 0 ]]; then
    log_warn "Running as root — sudo steps will be skipped."
    SUDO=""
else
    SUDO="sudo"
fi

if ! command -v apt-get &>/dev/null; then
    log_error "apt-get not found. This script targets Ubuntu/Debian."
    echo ""
    echo -e "  ${C_BOLD}For Fedora/RHEL, install manually:${C_RESET}"
    log_dim "sudo dnf install texlive-collection-xetex texlive-collection-latexextra \\"
    log_dim "                  texlive-collection-lang-portuguese latexmk \\"
    log_dim "                  liberation-sans-fonts"
    exit 1
fi
log_ok "apt-get detected"

# ── Install TeX Live packages ──
log_step "Installing TeX Live packages"
log_desc "xelatex, latexmk, texlive-latex-extra, texlive-lang-portuguese, fonts, poppler-utils"

$SUDO apt-get update -qq
$SUDO apt-get install -y \
    texlive-xetex \
    texlive-latex-extra \
    texlive-lang-portuguese \
    latexmk \
    fonts-liberation \
    fonts-cascadia-code \
    poppler-utils \
    2>&1 | tail -3

log_done "TeX Live packages installed"

# ── Install HarmonyOS Sans font ──
log_step "Installing HarmonyOS Sans font"

HARMONYOS_DEB_URL="https://github.com/zhiyuan1i/fonts-harmonyos-sans-cn/releases/download/v1.0.0/harmonyos_sans.deb"
HARMONYOS_DEB="/tmp/harmonyos_sans.deb"

if fc-list | grep -q "HarmonyOS Sans"; then
    log_ok "HarmonyOS Sans: already installed"
else
    log_desc "Downloading from GitHub releases..."
    if wget -q "$HARMONYOS_DEB_URL" -O "$HARMONYOS_DEB"; then
        $SUDO apt install -y "$HARMONYOS_DEB" 2>&1 | tail -2
        rm -f "$HARMONYOS_DEB"
        log_done "HarmonyOS Sans: installed"
    else
        log_warn "Failed to download HarmonyOS Sans — using fallback fonts"
        log_dim "Download manually from: $HARMONYOS_DEB_URL"
    fi
fi

# ── Update font cache ──
log_step "Updating font cache"
! fc-cache -f
log_ok "Font cache updated"

# ── Verify toolchain ──
log_step "Verifying toolchain and fonts"

verify() {
    if command -v "$1" &>/dev/null; then
        log_ok "$1: $($1 --version 2>/dev/null | head -1)"
    else
        log_error "$1 not found after installation"
        return 1
    fi
}

verify xelatex
verify latexmk

# Font checks
check_font() {
    if fc-list | grep -q "$1"; then
        log_ok "$1: available ($2)"
    else
        log_warn "$1 not found — $2 will fall back to $3"
    fi
}

check_font "HarmonyOS Sans"    "body text"      "Liberation Sans"
check_font "Liberation Sans"   "body fallback"  "Arial"
check_font "Cascadia Code"     "code font"      "Consolas or DejaVu Sans Mono"
check_font "DejaVu Sans Mono"  "code fallback"  "fontspec default"

# ── Install opencode skills ──
log_step "Installing opencode skills"

GLOBAL_SKILLS_DIR="$HOME/.config/opencode/skills"
SKILL_COUNT=0

for skill_file in "$SCRIPT_DIR"/templates/*/SKILL.md; do
    if [[ -f "$skill_file" ]]; then
        skill_name=$(awk '/^name:/{print $2}' "$skill_file")
        skill_dst_dir="$GLOBAL_SKILLS_DIR/$skill_name"
        mkdir -p "$skill_dst_dir"
        cp "$skill_file" "$skill_dst_dir/SKILL.md"
        log_ok "Skill '$skill_name' → $skill_dst_dir/SKILL.md"
        SKILL_COUNT=$((SKILL_COUNT + 1))
    fi
done

if [[ $SKILL_COUNT -eq 0 ]]; then
    log_warn "No skills found in templates/*/SKILL.md — skipping"
else
    log_dim "$SKILL_COUNT skill(s) installed — restart opencode to discover them"
    log_dim "Project-level discovery also works via opencode.json (skills.paths)"
fi

# ── Configure VS Code (user-level) ──
log_step "Configuring VS Code (user-level)"

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
    print(f"  \033[32m✓\033[0m Updated {settings_path}")
else:
    print(f"  \033[32m✓\033[0m {settings_path} already configured")
PYEOF

# Install LaTeX Workshop extension if VS Code CLI is available
if command -v code &>/dev/null; then
    log_desc "VS Code CLI: $(command -v code)"

    if code --install-extension James-Yu.latex-workshop --force 2>/dev/null; then
        log_ok "Extension: LaTeX Workshop (James-Yu.latex-workshop)"
    else
        log_warn "Failed to install LaTeX Workshop extension"
    fi

    # Optional: LTeX for spell/grammar checking
    if code --install-extension valentjn.vscode-ltex --force 2>/dev/null; then
        log_ok "Extension: LTeX (valentjn.vscode-ltex)"
    else
        log_warn "Failed to install LTeX extension (optional — spell/grammar checking)"
    fi
else
    log_warn "VS Code CLI (code) not found — extensions not installed"
    log_dim "Settings were still written to $VSCODE_USER_SETTINGS"
    log_dim "To install manually: https://code.visualstudio.com/ → LaTeX Workshop"
fi

# ── Test compilation ──
log_step "Test compilation"

PT_DIR="$SCRIPT_DIR/templates/guide/samples/pt"
EN_DIR="$SCRIPT_DIR/templates/guide/samples/en"

compile_sample() {
    local dir="$1" label="$2"
    if [[ -f "$dir/main.tex" ]]; then
        cd "$dir"
        latexmk -C main.tex 2>/dev/null
        if latexmk main.tex 2>/dev/null; then
            local pages=$(pdfinfo main.pdf 2>/dev/null | grep "^Pages:" | awk '{print $2}')
            log_ok "$label sample: ${pages:-?} pages"
            latexmk -C main.tex 2>/dev/null
        else
            log_warn "$label sample compile failed — check $dir/main.log"
        fi
    else
        log_warn "$label sample not found at $dir — skipping"
    fi
}

compile_sample "$PT_DIR" "Portuguese"
compile_sample "$EN_DIR" "English"

# ── Summary ──
echo ""
echo -e "${C_BOLD}${C_GREEN}  ✓ Setup complete${C_RESET}"
echo ""
printf "  ${C_DIM}%-24s${C_RESET} %s\n" "Engine:"             "XeLaTeX (TeX Live)"
printf "  ${C_DIM}%-24s${C_RESET} %s\n" "Build tool:"         "latexmk (.latexmkrc → xelatex)"
printf "  ${C_DIM}%-24s${C_RESET} %s\n" "Body font:"          "HarmonyOS Sans → Liberation Sans → Arial"
printf "  ${C_DIM}%-24s${C_RESET} %s\n" "Code font:"          "Cascadia Code → Consolas → DejaVu Sans Mono"
printf "  ${C_DIM}%-24s${C_RESET} %s\n" "Skill:"              "/skill huawei-template-guide"
printf "  ${C_DIM}%-24s${C_RESET} %s\n" "VS Code:"            "LaTeX Workshop (user-level, -cd -xelatex)"
printf "  ${C_DIM}%-24s${C_RESET} %s\n" "Timezone:"           "America/Sao_Paulo (GMT-3, overridable)"
echo ""
echo -e "  ${C_BOLD}Next steps:${C_RESET}"
log_dim "1. Open this project in opencode"
log_dim "2. Run /skill huawei-template-guide to create a new guide"
log_dim "3. Or open in VS Code — save a .tex file to auto-compile"
log_dim "4. Or compile manually:"
log_dim "   cd templates/guide/samples/pt && latexmk main.tex   # Portuguese"
log_dim "   cd templates/guide/samples/en && latexmk main.tex   # English"
echo ""
echo -e "  ${C_BOLD}Optional:${C_RESET}"
log_dim "Consolas is optional — Cascadia Code is the default code font"
echo ""
