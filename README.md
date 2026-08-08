# Huawei Document Templates

A collection of LaTeX templates for Huawei Cloud documents. Each template
lives under `templates/<name>/` and is self-contained: class file, samples,
skill, assets, and build config. Documents compile to PDF via XeLaTeX.

## Quick start

```bash
git clone <repo-url> Huawei-doc-templates
cd Huawei-doc-templates
./install.sh          # installs XeLaTeX, latexmk, fonts, opencode skills, VS Code extension
```

Then open the project in [opencode](https://opencode.ai) and run:

```
/skill huawei-template-guide
```

to create a new guide document. The skill guides you through title,
language, and content, then compiles and verifies the PDF.

## Requirements

- **Engine:** XeLaTeX or LuaLaTeX (required — templates use `fontspec`).
  `pdflatex` **does not work**.
- **latexmk:** handles multi-pass compilation (TOC, page numbers). Included
  with TeX Live / MiKTeX.
- **fvextra ≥ 1.5:** provides `backgroundcolor` for code blocks. `install.sh`
  updates it automatically; on older TeX Live (2023), see
  [Manual setup](#linux) below.
- **Fonts** (loaded from the OS, not the LaTeX tree):
  - **HarmonyOS Sans** — body text. Falls back to Liberation Sans → Arial.
  - **Cascadia Code** — code. Falls back to Consolas → DejaVu Sans Mono.
  - Documents **always compile** even without brand fonts; missing fonts
    only reduce visual fidelity.
- **OS:** Ubuntu/Debian (WSL or native) for `install.sh`. Manual setup
  available for Fedora and Windows.
- **opencode** (optional): for the `/skill <name>` workflow.

## Installation

### Linux (Ubuntu/Debian) — automated

```bash
./install.sh
```

`install.sh` is idempotent — safe to re-run. It installs:

- XeLaTeX + latexmk + LaTeX packages (`texlive-xetex`, `texlive-latex-extra`,
  `texlive-lang-portuguese`)
- fvextra ≥ 1.5 (downloaded from CTAN if the system version is too old)
- HarmonyOS Sans font (from GitHub releases, SHA-256 verified)
- Cascadia Code font (via `fonts-cascadia-code`)
- opencode skills (copies each `templates/*/SKILL.md` to `~/.config/opencode/skills/`)
- VS Code LaTeX Workshop extension + settings (local and remote)

### Linux (Ubuntu/Debian) — manual

```bash
sudo apt install texlive-xetex texlive-latex-extra texlive-lang-portuguese \
                  latexmk fonts-liberation fonts-cascadia-code
```

> `poppler-utils` (provides `pdfinfo`) is only needed by `install.sh`'s test
> compilation step — not for document compilation itself.

**Fallback** — if a LaTeX package is missing, install the full collection
(~5–6 GB, simplest fix): `sudo apt install texlive-full`.

#### Package mapping (for troubleshooting)

The `guide.cls` class loads these LaTeX packages. Here's which `texlive-*`
package provides each one:

| LaTeX package | Provided by | Notes |
|---|---|---|
| `fontspec` | `texlive-xetex` | Requires XeLaTeX/LuaLaTeX |
| `geometry`, `booktabs`, `caption` | `texlive-latex-recommended` | Pulled as dependency of `texlive-xetex` |
| `xcolor`, `graphicx`, `fancyhdr`, `array`, `babel`, `hyperref` | `texlive-latex-base` | Core, always installed |
| `titlesec`, `tocloft`, `enumitem`, `fancyvrb`, `tcolorbox`, `ragged2e`, `needspace`, `etoolbox`, `environ`, `trimspaces` | `texlive-latex-extra` | |
| `pgf` | `texlive-pictures` | Pulled as dependency of `texlive-latex-extra` |
| `fvextra` | `texlive-latex-extra` | **Often outdated** — see below if ≥1.5 needed |
| `babel` (brazilian) | `texlive-lang-portuguese` | Portuguese language support |

#### Updating fvextra (if code block backgrounds look wrong)

`fvextra ≥ 1.5` introduced `backgroundcolor`. TeX Live 2023 ships an older
version. `install.sh` handles this automatically; manually:

```bash
wget https://mirrors.ctan.org/macros/latex/contrib/fvextra.zip
unzip fvextra.zip -d /tmp/fvextra-build
cd /tmp/fvextra-build/fvextra && latex fvextra.ins
sudo cp fvextra.sty "$(kpsewhich fvextra.sty)"
sudo texhash
```

#### Verifying the installation

```bash
xelatex --version          # must show XeTeX
latexmk --version          # must show latexmk 4.70+
fc-list | grep "HarmonyOS"  # optional — body font
fc-list | grep "Cascadia"   # optional — code font
```

Then test-compile a sample:

```bash
cd examples/guide/pt && latexmk main.tex
```

If it produces `main.pdf` without errors, the installation is complete.

### WSL (Windows Subsystem for Linux)

`install.sh` works directly in WSL — it's a bash script using `apt-get`.
A few WSL-specific notes:

- **Fonts go in the Linux filesystem**, not the Windows side. Install to
  `~/.local/share/fonts/` (current user) or `/usr/local/share/fonts/` (all
  users), then run `fc-cache -f` in the WSL terminal. Windows-installed fonts
  are not visible to `xelatex` running in WSL.
- **VS Code** — use the **WSL** extension (formerly "Remote - WSL") to open
  the project. LaTeX Workshop then runs in the WSL context using the Linux
  `xelatex`/`latexmk`. Keep `.tex` files in the WSL filesystem for performance
  (accessing Windows-side files from WSL is slow).
- **PDF preview** — with WSLg (Windows 11), VS Code's built-in PDF viewer
  works out of the box. Without WSLg, open the PDF from Windows:
  `explorer.exe main.pdf` or navigate to `\\wsl$\<distro>\home\...`.
- **Timezone** — WSL respects the `TZ` environment variable, so the
  `.latexmkrc` default (`America/Sao_Paulo`) works correctly without
  overrides.

### Linux (Fedora/RHEL) — manual

```bash
sudo dnf install texlive-collection-xetex texlive-collection-latexextra \
                  texlive-collection-lang-portuguese latexmk \
                  liberation-sans-fonts fonts-cascadia-code
```

Fallback that pulls everything (~5–6 GB): `sudo dnf install texlive-scheme-full`.

### Windows — manual

1. **Install MiKTeX** — download from <https://miktex.org/download>.
   Keep **"Install missing packages on-the-fly"** enabled so packages like
   `fontspec` are downloaded automatically. (TeX Live
   <https://www.tug.org/texlive/> is an alternative.)

2. **Verify `xelatex`** — run `xelatex --version` in a terminal. If not found,
   restart the computer or add the MiKTeX `bin` folder to PATH.

3. **Install fonts** (optional, for full fidelity) — install **HarmonyOS Sans**
   and **Cascadia Code** via the Windows Fonts control panel (right-click
   `.ttf` → Install). Without them, the template falls back and still compiles.

4. **Compile** — see [Compilation](#compilation) below. For `latexmk`, install
   [Strawberry Perl](https://strawberryperl.com/).

5. **Timezone** — the `.latexmkrc` sets `TZ=America/Sao_Paulo` for the cover
   page timestamp. On Windows, `TZ` may not be respected by Perl/TeX. If the
   cover time is wrong, set it manually: `set TZ=America/Sao_Paulo`
   (Command Prompt) or `$env:TZ="America/Sao_Paulo"` (PowerShell).

### Installing fonts manually (all OSes)

- **HarmonyOS Sans** — free for commercial use; download from
  [GitHub](https://github.com/zhiyuan1i/fonts-harmonyos-sans-cn/releases)
  (`.deb` package) or
  [Huawei Design](https://developer.huawei.com/consumer/en/design/resource/).
- **Cascadia Code** — open source from Microsoft: `sudo apt install fonts-cascadia-code`
  or download from [GitHub](https://github.com/microsoft/cascadia-code).
- **Consolas** — optional fallback; a Microsoft font, not freely redistributable.
  Copy from a licensed Windows install if available.

On Linux, after installing fonts, rebuild the cache:

```bash
fc-cache -f
```

## VS Code setup (recommended)

[VS Code](https://code.visualstudio.com/) with the **LaTeX Workshop** extension
gives you syntax highlighting, compile-on-save, live PDF preview, and SyncTeX
(click in PDF → source line, and vice versa).

The repo ships `.vscode/settings.json` pre-configured for **latexmk (XeLaTeX)**.

### Step-by-step

1. **Install VS Code** — <https://code.visualstudio.com/>.
2. **Install LaTeX Workshop** — Extensions sidebar (`Ctrl+Shift+X`), search
   **LaTeX Workshop** (publisher: *James Yu*), click Install. Or:
   ```bash
   code --install-extension James-Yu.latex-workshop
   ```
3. **Open the repo root** in VS Code. The settings are auto-detected.
4. **Open any `.tex` file** and press `Ctrl+S` to compile. The PDF preview
   opens in a side tab.

### Shortcuts

| Action | Shortcut |
|---|---|
| Build (compile) | `Ctrl+Alt+B` / `Cmd+Option+B` |
| View PDF | `Ctrl+Alt+V` / `Cmd+Option+V` |
| SyncTeX: PDF → source | `Ctrl+click` in the PDF |
| SyncTeX: source → PDF | `Ctrl+Alt+J` / `Cmd+Option+J` |

### Optional: spell and grammar checking

Install the **LTeX** extension (publisher: *valentjn*) for inline grammar and
spell checking. Supports Portuguese and English.

> **pdflatex won't work.** The class loads `fontspec` (system fonts), which
> requires XeLaTeX or LuaLaTeX. The included settings enforce XeLaTeX.

## Compilation

### Using latexmk (recommended)

`latexmk` handles multi-pass (TOC, page numbers) automatically. Each project
folder has a `.latexmkrc` that sets XeLaTeX and `TEXINPUTS`.

```bash
cd examples/guide/pt && latexmk main.tex   # Portuguese sample
cd examples/guide/en && latexmk main.tex   # English sample
cd examples/setup-guide && latexmk setup-guide.tex   # setup guide
```

### Using xelatex directly

Run **twice** so the TOC and page numbers settle:

```bash
cd examples/guide/pt
xelatex main.tex && xelatex main.tex
```

### Using the Makefile

```bash
make samples    # compile PT + EN samples
make examples   # compile setup-guide, copy PDF to repo root
make            # all of the above
make clean      # remove all build artifacts
```

### Clean builds

```bash
latexmk -C main.tex   # full clean (removes PDF + aux files)
latexmk -c main.tex   # aux only (keeps PDF)
```

## Timezone

The cover page shows the compilation date and time via `\today` and TeX's
`\time` primitive. The template sets a default TZ of `America/Sao_Paulo`
(GMT-3) in its `.latexmkrc` files. To use a different timezone, override it
in your project's `.latexmkrc`:

```perl
$ENV{TZ} = "UTC";  # override the template default
```

Pass the `[notime]` class option to hide the time on the cover page.

## Templates

| Template | Skill | Description |
|---|---|---|
| [`guide`](templates/guide/) | `/skill huawei-template-guide` | Huawei Cloud guide — branded cover, header, TOC, giant chapter numbers, objectives block, code blocks, callout boxes, badges, changelog. Portuguese (default) and English. |

See each template's `SKILL.md` for the full command and environment reference:
- [`templates/guide/SKILL.md`](templates/guide/SKILL.md) — guide template commands

## Project layout

```
.
├── AGENTS.md               # project standards and locked decisions
├── install.sh               # one-command setup (base deps + skills + VS Code)
├── Makefile                 # build convenience (make samples/examples/clean)
├── opencode.json            # skill discovery: scans templates/ for SKILL.md
├── README.md                # this file (comprehensive guide for all templates)
├── LICENSE                  # MIT
├── .vscode/
│   └── settings.json        # VS Code + LaTeX Workshop config (latexmk recipe)
├── templates/
│   └── guide/               # self-contained template + skill
│       ├── SKILL.md          # opencode skill + agent command reference
│       ├── README.md         # template-specific details (brief)
│       ├── guide.cls         # the class — all formatting lives here
│       ├── .latexmkrc        # latexmk config (XeLaTeX, TZ=America/Sao_Paulo)
│       └── assets/           # logos, sample images, example scripts
└── examples/                 # all example documents and samples
    ├── guide/               # samples for the guide template
    │   ├── pt/               # Portuguese sample
    │   │   ├── .latexmkrc    # TEXINPUTS → templates/guide/
    │   │   └── main.tex
    │   └── en/               # English sample
    │       ├── .latexmkrc
    │       └── main.tex
    └── setup-guide/          # real-world ECS + SSH + MaaS gateway guide
        ├── setup-guide.tex
        ├── .latexmkrc
        └── assets/
```

## How it works

- **`install.sh`** installs the base: XeLaTeX, latexmk, LaTeX packages, fallback
  fonts, VS Code extensions, and copies each template's skill to the global
  opencode path (`~/.config/opencode/skills/`).
- **`opencode.json`** registers `templates/` as a skill discovery path, so
  OpenCode finds each template's `SKILL.md` automatically — **no need to run
  `install.sh`** for project-level skill discovery. The global install is only
  needed when working outside this repo.
- **Each template** in `templates/<name>/` is self-contained: class file,
  skill, build config, assets. Add a new template by creating a new directory
  with a `SKILL.md` — it's auto-discovered.
- **Each document** lives in its own folder with its own `.latexmkrc` that
  sets `TEXINPUTS` pointing to the template directory. Never scatter `.tex`
  files directly in the workspace root.

## Adding a new template

1. Create `templates/<name>/` with:
   - `<name>.cls` — the LaTeX class file
   - `SKILL.md` — skill definition (YAML frontmatter: `name: huawei-template-<name>`,
     `description: ...`)
   - `README.md` — brief template-specific docs
   - `.latexmkrc` — latexmk config (XeLaTeX)
   - `assets/` — logos, sample images
2. Add samples in `examples/<name>/pt/` and `examples/<name>/en/`.
3. Add a row to the Templates table above.
4. `install.sh` will auto-discover and install the skill on next run.

See [`AGENTS.md`](AGENTS.md) for full project standards and locked decisions.

## License

MIT — see [LICENSE](LICENSE).
