# AGENTS.md — Project Standards

This file defines the conventions, locked decisions, and workflows for
any agent or human working on this repository. Read it before making
changes.

---

## Project overview

A collection of LaTeX templates for Huawei Cloud documents. Each template
lives under `templates/<name>/` and is self-contained: class file, samples,
skill, assets, and build config. Documents compile to PDF via XeLaTeX.

---

## Locked decisions (do NOT change)

These decisions were explicitly made and must not be reversed without user
approval. Changing them breaks existing documents and reproducibility.

### L1. Engine: XeLaTeX only
- `guide.cls` loads `fontspec`, which requires XeLaTeX or LuaLaTeX.
- `pdflatex` will **not** work. Never remove `fontspec` or switch to pdflatex.
- `.latexmkrc` sets `$pdf_mode = 5` (xelatex). Do not change this.

### L2. Class name: `guide` (not `labguide`)
- The class was renamed from `labguide` to `guide`. The old name is gone.
- `\documentclass{guide}` or `\documentclass[english]{guide}`.

### L3. Callout box names: `aviso`, `dica`, `infobox`
- `info` was renamed to `infobox` to avoid package name collisions.
- Never reintroduce an `info` environment.

### L4. Template default timezone is America/Sao_Paulo (GMT-3)
- The template's `.latexmkrc` files set `$ENV{TZ} = "America/Sao_Paulo"`.
- Projects can override TZ in their own `.latexmkrc` (last one wins).
- This default matches the primary user timezone; override for other regions.

### L5. Cover page shows version + date + time automatically
- `\setdocdate` defaults to `\today` (compilation date).
- Time comes from TeX's `\time` primitive (HH:MM, respects TZ env).
- Both are shown on the cover page by default. Pass `[notime]` class option
  to hide the time.
- `\setdocdate{...}` can override the date, but time is always compilation
  time (when shown).

### L6. Self-contained project folders
- Every document lives in its own folder with its own `.latexmkrc`.
- Never scatter `.tex` files directly in the workspace root.
- The `.latexmkrc` sets `TEXINPUTS` pointing to `templates/guide/`.

### L7. Skill prefix: `huawei-template-`
- All skills are named `huawei-template-<name>` (e.g. `huawei-template-guide`).
- The prefix is set in the SKILL.md frontmatter `name` field.
- `install.sh` extracts the name from frontmatter, not from the directory.

### L8. Font fallback chain
- Main font: HarmonyOS Sans -> Liberation Sans -> Arial -> fontspec default.
- Mono font: Cascadia Code -> Consolas -> DejaVu Sans Mono.
- All font loads use `\IfFontExistsTF` — never hard-fail on a missing font.
- Documents must always compile, even without brand fonts installed.

### L9. Colors are hardcoded to Huawei brand
- `huaweired` (`#C7000B`), `codebg` (`#F6F8FA`), `codetext` (`#1F2328`),
  `linkblue` (`#0000FF`), `ruleblack` (`#000000`).
- Callout colors: `warningbg/fg` (amber), `tipbg/fg` (green), `infobg/fg` (blue).
- Do not change these values. They match the Huawei house style.

### L10. Body order is fixed
- `\makecover` -> `\sumario` -> `\startbody` -> sections.
- `\startbody` resets page numbering to 1.
- Do not reorder or skip these commands.

---

## Project structure

```
.
+-- AGENTS.md               # this file
+-- install.sh               # one-command setup
+-- opencode.json            # skill discovery (scans templates/)
+-- README.md                # collection index
+-- LICENSE                  # MIT
+-- .vscode/settings.json    # latexmk as default recipe
+-- .github/workflows/build.yml  # CI: compile samples on push/PR
+-- templates/
    +-- guide/               # the guide template
        +-- SKILL.md          # opencode skill + agent reference
        +-- README.md         # human-readable docs
        +-- guide.cls         # all formatting lives here
        +-- .latexmkrc        # XeLaTeX, TZ=America/Sao_Paulo
        +-- assets/           # logos and sample images
        +-- samples/
            +-- pt/            # Portuguese sample
            +-- en/            # English sample
+-- examples/                 # reference projects using the template
    +-- setup-guide/          # ECS + SSH + MaaS gateway setup guide
        +-- setup-guide.tex
        +-- .latexmkrc        # TEXINPUTS + TZ override
```

---

## Compilation

- **Always use `latexmk`** — it handles multi-pass (TOC, page numbers).
- **Never use `pdflatex`** — will fail on `fontspec`.
- `xelatex` directly works but needs two manual runs for the TOC.
- `.latexmkrc` in each folder sets `$pdf_mode = 5` (xelatex) and `TEXINPUTS`.
- Clean builds: `latexmk -C` (full clean), `latexmk -c` (aux only).

### Timezone
- Template `.latexmkrc` files: `$ENV{TZ} = "America/Sao_Paulo"` (locked, see L4).
- Project `.latexmkrc` files: can override TZ (last one wins).
- `\today` and `\time` respect the TZ environment variable.

---

## Template features (reference)

### Class options
| Option | Effect |
|---|---|
| `english` | English labels (default: Portuguese) |
| `indentbody` | Indent body text by `\contentindent` (default: off) |
| `notime` | Hide compilation time on cover page (default: show) |

### Preamble commands
| Command | Purpose |
|---|---|
| `\setguidetitle{...}` | Cover title |
| `\setheadertitle{...}` | Header text on every page |
| `\setcovertext{...}` | Line under cover logo |
| `\setheaderlogo{path}` | Header logo (default: `assets/huawei-logo-header.png`) |
| `\setcoverlogo{path}` | Cover logo (default: `assets/huawei-logo-cover.png`) |
| `\setdocversion{1.0.0}` | Version on cover page |
| `\setdocdate{...}` | Date on cover page (optional, defaults to `\today`) |

### Document structure commands
| Command | Purpose |
|---|---|
| `\makecover` | Render cover (call right after `\begin{document}`) |
| `\sumario` | Render TOC + page break |
| `\startbody` | Mark body start, reset page numbering to 1 |

### Environments
| Environment | Use |
|---|---|
| `objetivos` | Objectives + prerequisites block |
| `codigo` | Verbatim code block (optional language hint: `[bash]`) |
| `aviso` | Warning callout (amber) |
| `dica` | Tip callout (green) |
| `infobox` | Info callout (blue) |
| `changelog` | Version history block |

### Commands
| Command | Produces |
|---|---|
| `\objgeral{...}` | General objective label + text |
| `\objpratica{...}` | Practice objective label + text |
| `\prerequisitos` | Prerequisites label |
| `\passoapasso` | Step-by-step label |
| `\code{...}` | Inline monospace code |
| `\param{...}` | Filename/parameter in italic |
| `\codigoarquivo[lang]{file}` | Code block from external file |
| `\imagem{file}` | Centered image (default `0.85\linewidth`) |
| `\imagemc{file}{caption}` | Centered image with caption |
| `\nota{...}` | Italic observation |
| `\weblink{url}{text}` | Blue clickable link, no underline |
| `\badge{...}` | Inline red label with white text |
| `\changelogentry{ver}{date}{items}` | One changelog entry |

---

## How to create a new skill

Skills are discovered from `templates/<name>/SKILL.md`. The `opencode.json`
at the repo root registers `templates/` as a discovery path.

### Steps

1. **Create the template directory** `templates/<name>/` with:
   - `<name>.cls` — the LaTeX class file
   - `SKILL.md` — the skill definition (see format below)
   - `README.md` — human-readable documentation
   - `.latexmkrc` — latexmk config (XeLaTeX, no TZ)
   - `assets/` — logos, sample images
   - `samples/pt/` and `samples/en/` — sample documents, each with `.latexmkrc`

2. **SKILL.md format** — must start with YAML frontmatter:
   ```yaml
   ---
   name: huawei-template-<name>
   description: <when to trigger this skill>
   ---
   ```
   - The `name` field MUST have the `huawei-template-` prefix (locked, see L7).
   - `install.sh` reads this `name` field to determine the install directory.
   - The `description` field determines when the skill triggers. Keep it
     specific to avoid false activations.

3. **SKILL.md body** should include:
   - **When to use** — clear trigger conditions
   - **Quick start** — step-by-step for creating a new document
   - **Commands reference** — all commands and environments the class provides
   - **Skeleton** — a minimal `.tex` template the skill can use as a starting
     point
   - **Hard requirements** — engine, fonts, compilation rules
   - **Project folder convention** — always create a self-contained folder
   - **Timezone note** — document that TZ is per-project, not template-level

4. **Add to `install.sh`** — the script auto-discovers templates by scanning
   `templates/*/SKILL.md`. No changes needed if the structure is correct.

5. **Add to root `README.md`** — add a row to the Templates table.

6. **Add to CI** (`.github/workflows/build.yml`) — add a compile step for the
   new template's samples.

### Skill naming rules
- Prefix: `huawei-template-` (locked, see L7)
- Examples: `huawei-template-guide`, `huawei-template-report`
- The skill name in frontmatter must match the directory name under `templates/`
  minus the `huawei-template-` prefix.

---

## How to extend the existing template

### Adding a new command to `guide.cls`
1. Define the command in `guide.cls` with a `\newcommand`.
2. Use internal prefix `\lg@` for internal macros (e.g. `\lg@docversion`).
3. Add the command to the reference tables in `SKILL.md` and `README.md`.
4. Demonstrate the command in both samples (`samples/pt/` and `samples/en/`).
5. Compile both samples to verify: `latexmk main.tex` from each folder.
6. Commit only if both samples compile without errors.

### Adding a new environment
- Same steps as above, but use `\newenvironment` or `tcolorbox`.
- If using `tcolorbox`, add colors to the CORES section with `\definecolor`.
- Document the environment's color, border, and breakability.

### Adding a new color
- Define in the CORES section of `guide.cls` with `\definecolor`.
- Use HTML hex values: `\definecolor{name}{HTML}{RRGGBB}`.
- Do not change existing color values (locked, see L9).

---

## CI/CD

- `.github/workflows/build.yml` compiles both samples on every push/PR that
  touches `templates/**`.
- CI installs `texlive-xetex`, `texlive-latex-extra`,
  `texlive-lang-portuguese`, `latexmk`, `fonts-liberation`.
- CI does NOT install Consolas (proprietary) — the fallback
  chain must handle this (locked, see L8). HarmonyOS Sans and Cascadia Code
  ARE installed (free and open source respectively).
- PDFs are uploaded as artifacts for inspection.

---

## File editing rules

- **`guide.cls`** — the single source of truth for all formatting. Changes
  here affect every document. Test with both samples before committing.
- **`SKILL.md`** — must stay in sync with `guide.cls`. Every command in the
  class must be documented here. Every locked decision must be respected.
- **`README.md`** (template) — human-readable version of SKILL.md. Keep the
  command tables in sync.
- **`AGENTS.md`** (this file) — update when standards change or new locked
  decisions are made.
- **Samples** — must always compile. They are the CI gate and the user's
  reference. Any new feature must be demonstrated in both samples.
- **`install.sh`** — reads skill name from SKILL.md frontmatter. Do not
  hardcode skill names in the script.

---

## Git conventions

- Commit messages: imperative mood, concise first line, detail in body.
- Never commit build artifacts (`.pdf`, `.aux`, `.log`, `.out`, `.toc`,
  `.xdv`, `.fls`, `.fdb_latexmk`, `.synctex.gz`). They are in `.gitignore`.
- The setup guide PDF (`examples/setup-guide/setup-guide.pdf`) is also gitignored.
- Samples are the CI gate — a commit that breaks sample compilation must not
  be pushed to `main`.
