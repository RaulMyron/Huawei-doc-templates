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
- Main font: HarmonyOS Sans -> Liberation Sans (sole fallback).
- Mono font: Cascadia Code -> DejaVu Sans Mono (sole fallback).
- Brand fonts are loaded with `\IfFontExistsTF`; if missing, a single
  fallback is used with a class warning.
- Removed fallbacks: Arial, Consolas, fontspec default.
- `install.sh` installs both brand fonts; the fallbacks are safety nets.

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
+-- Makefile                 # build convenience (make samples/examples/clean)
+-- opencode.json            # skill discovery (scans templates/)
+-- README.md                # comprehensive guide for all templates
+-- LICENSE                  # MIT
+-- .vscode/settings.json    # latexmk as default recipe
+-- templates/
    +-- guide/               # the guide template
        +-- SKILL.md          # opencode skill + agent reference
        +-- README.md         # human-readable docs
        +-- guide.cls         # all formatting lives here
        +-- .latexmkrc        # XeLaTeX, TZ=America/Sao_Paulo
        +-- assets/           # logos, sample images, example scripts
+-- examples/                 # all example documents and samples
    +-- guide/               # samples for the guide template
        +-- pt/               # Portuguese sample
        +-- en/               # English sample
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

## Sample and example conventions

- **Two samples per template**: each template `<name>` has exactly two samples
  in `examples/<name>/pt/` and `examples/<name>/en/` (Portuguese and English).
  Samples demonstrate all available commands and environments.
- **Template explanation**: each sample includes an `\begin{infobox}` on the
  first page explaining which template it uses and what it demonstrates.
- **Setup guide is additional**: `examples/setup-guide/` is not a sample — it
  is a real-world document used for validation and actual installation
  instructions. It exercises features the samples don't (e.g. `\menu`,
  `\badge`, multi-entry changelog).
- **Setup guide PDF in root**: `make examples` copies `setup-guide.pdf` to the
  repo root for easy reading. The copy is gitignored (build artifact).
- **Self-contained**: each sample/example has its own `.latexmkrc` with
  `TEXINPUTS` pointing to `templates/<name>/`. Never share `.latexmkrc` files.

---

## Template features

See `templates/guide/SKILL.md` for the full command and environment reference
(class options, preamble commands, document structure commands, environments,
and content commands). SKILL.md is the canonical source; `templates/guide/README.md`
has the human-readable version with examples.

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
   - Samples live in `examples/<name>/pt/` and `examples/<name>/en/` (see below)

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
4. Demonstrate the command in both samples (`examples/guide/pt/` and `examples/guide/en/`).
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

## File editing rules

- **`guide.cls`** — the single source of truth for all formatting. Changes
  here affect every document. Test with both samples before committing.
- **`SKILL.md`** — canonical command and environment reference. Must stay in
  sync with `guide.cls`. Every command in the class must be documented here.
  Every locked decision must be respected.
- **`README.md`** (root) — comprehensive installation, setup, and project info
  for all templates. The single source of truth for environment setup,
  requirements, compilation, and project layout.
- **`README.md`** (template) — brief template-specific details only (class
  options, format tokens, customization). Points to root README for setup and
  SKILL.md for commands. Do not duplicate content from either.
- **`AGENTS.md`** (this file) — update when standards change or new locked
  decisions are made.
- **Samples** — must always compile. They are the user's reference. Any new
  feature must be demonstrated in both samples.
- **`install.sh`** — reads skill name from SKILL.md frontmatter. Do not
  hardcode skill names in the script.

---

## Git conventions

- Commit messages: imperative mood, concise first line, detail in body.
- Never commit build artifacts (`.pdf`, `.aux`, `.log`, `.out`, `.toc`,
  `.xdv`, `.fls`, `.fdb_latexmk`, `.synctex.gz`). They are in `.gitignore`.
- The setup guide PDF (`examples/setup-guide/setup-guide.pdf`) is also gitignored.
- A commit that breaks sample compilation must not be pushed to `main`.
- **One change, commit, push.** Make one logical change, commit it, and push
  immediately. Do not accumulate multiple unpushed commits. This keeps the
  remote in sync, makes each change individually revertable, and avoids losing
  work to a local-only working tree.
