# Huawei Cloud Guide — LaTeX Template

A LaTeX template that produces a Huawei Cloud guide PDF: cover page, header,
table of contents, giant chapter numbers, objectives box, code blocks,
callout boxes, badges, colors, spacing, and fonts.

> **Language note:** by default the guide renders in **Portuguese** — the
> class loads `babel` with the `brazilian` language and built-in labels such as
> *Sumário*, *Objetivo Geral:*, *Objetivo da prática:*, *Pré-requisitos:* and
> *Passo a passo:* are in Portuguese. Pass the **`english`** class option
> (`\documentclass[english]{guide}`) to switch all labels to English and load
> `babel` with `english` instead. See [Class options](#class-options) below.

## Project structure

```
.
├── guide.cls          # the class — all formatting lives here
├── README.md           # this file (human guide)
├── SKILL.md            # agent orientation
├── .latexmkrc          # latexmk config (uses XeLaTeX by default)
├── assets/
│   ├── huawei-logo-header.png   # header logo
│   ├── huawei-logo-cover.png    # cover logo
│   ├── exemplo-menu.png         # sample image
│   └── exemplo-login.png        # sample image
└── samples/            # self-contained project folders by language
    ├── pt/
    │   ├── .latexmkrc  # TEXINPUTS=../../ so guide.cls is found
    │   └── main.tex    # sample document in Portuguese (starting point)
    └── en/
        ├── .latexmkrc
        └── main.tex    # sample document in English (uses [english] option)
```

## Environment setup

The template needs XeLaTeX (or LuaLaTeX) and a couple of system fonts. Setup
differs by operating system — follow the section for yours.

### Windows

1. **Install MiKTeX** — download the 64-bit installer from
   <https://miktex.org/download> and follow the wizard with the default options.
   Keep **"Install missing packages on-the-fly"** enabled so packages like
   `fontspec` are downloaded automatically on first compile. (TeX Live
   <https://www.tug.org/texlive/> is an alternative; MiKTeX is lighter on
   Windows.)

2. **Verify `xelatex`** — open Command Prompt or PowerShell and run
   `xelatex --version`. If you get "command not found", restart the computer
   (the installer adjusts the PATH) or manually add the MiKTeX `bin` folder —
   e.g. `C:\Users\YOUR_USER\AppData\Local\Programs\MiKTeX\miktex\bin\x64` — to
   the environment variables.

3. **Install the fonts** (optional, for full fidelity) — install **Huawei Sans**
   and **Consolas** via the Windows Fonts control panel (right-click the
   `.ttf` → Install). Without them the template falls back to Liberation Sans /
   Arial and DejaVu Sans Mono and still compiles.

4. **Compile** — open a Command Prompt in the project folder and run:
   ```
   xelatex main.tex
   xelatex main.tex
   ```
   Run **twice** so the TOC and page numbers settle. To automate, use
   `latexmk -xelatex main.tex` (needs Perl — install
   [Strawberry Perl](https://strawberryperl.com/) if missing).

5. **Missing packages** — if a compile error mentions a missing package, MiKTeX
   usually prompts to install it automatically — accept.

### Linux

1. **Install TeX Live and latexmk.**

   Debian/Ubuntu (minimal — provides `xelatex`, every package the template
   needs, and Brazilian Portuguese babel support):
   ```
   sudo apt install texlive-xetex texlive-lang-portuguese latexmk
   ```
   Fedora (minimal):
   ```
   sudo dnf install texlive-collection-xetex texlive-collection-latexextra \
                     texlive-collection-lang-portuguese latexmk
   ```
   Fallback that pulls in everything (~5–6 GB; simplest if a package is
   missing): `sudo apt install texlive-full` (Debian/Ubuntu) or
   `sudo dnf install texlive-scheme-full` (Fedora).

2. **Verify `xelatex`** — run `xelatex --version`. Distro packages put the
   binary in `/usr/bin` (no PATH setup needed). If you installed upstream TeX
   Live via `install-tl`, add its bin folder to `PATH`, e.g.
   `export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"` in `~/.bashrc`.

3. **Install the fonts** (optional, for full fidelity) — copy font files into
   `~/.local/share/fonts/` (current user) or `/usr/local/share/fonts/` (all
   users), then rebuild the cache:
   ```
   fc-cache -f
   ```
   - **Huawei Sans** — proprietary; obtain from Huawei and copy the
     `.ttf`/`.otf` files in.
   - **Consolas** — a Microsoft font, not freely redistributable and not in
     `ttf-mscorefonts-installer`; copy it from a licensed Windows install
     (`C:\Windows\Fonts\consola*.ttf`) if you have one.
   - Without these, the template falls back to **DejaVu Sans Mono** (preinstalled
     on virtually all Linux distros) and still compiles.

4. **Compile** — in the sample folder (e.g., `samples/pt/`):
   ```
   cd samples/pt
   xelatex main.tex
   xelatex main.tex
   ```
   Run **twice** so the TOC and page numbers settle. Or automate with
   `latexmk main.tex` (Perl is preinstalled on Linux, so `latexmk`
   works once the package above is installed).

5. **Missing packages** — install the relevant `texlive-*` package via your
   package manager, or fall back to `texlive-full` / `texlive-scheme-full`.

### Code editor — VS Code with LaTeX Workshop (recommended)

[VS Code](https://code.visualstudio.com/) with the **LaTeX Workshop** extension
gives you syntax highlighting, compile-on-save, a live PDF preview side-by-side,
and SyncTeX (click in the PDF to jump to the source line, and vice versa).

This template ships a ready-made `.vscode/settings.json` at the repo root
pre-configured for **latexmk (XeLaTeX)**, so the build works out of the box —
just open the repo root and start editing.

#### Step-by-step setup

1. **Install VS Code** — download from <https://code.visualstudio.com/> and
   follow the installer for your OS.

2. **Install the LaTeX Workshop extension** — open VS Code, go to the Extensions
   sidebar (`Ctrl+Shift+X` / `Cmd+Shift+X`), search for **LaTeX Workshop**
   (publisher: *James Yu*), and click **Install**. Or from the terminal:
   ```bash
   code --install-extension James-Yu.latex-workshop
   ```

3. **Open the project in VS Code** — `File → Open Folder…` and select the
   repo root. The `.vscode/settings.json` at the root is pre-configured for
   XeLaTeX (via `latexmk`), so LaTeX Workshop never falls back to pdflatex.

4. **Open `samples/pt/main.tex`** and press `Ctrl+S` (`Cmd+S` on macOS) to save. LaTeX
   Workshop compiles with XeLaTeX automatically (two passes for the TOC) and
   opens the PDF preview in a side tab.

5. **View the PDF** — if the preview doesn't open automatically, click the
   **View LaTeX PDF** icon in the top-right of the editor, or press
   `Ctrl+Alt+V` (`Cmd+Option+V` on macOS).

#### Useful shortcuts

| Action | Shortcut |
|---|---|
| Build (compile) | `Ctrl+Alt+B` / `Cmd+Option+B` |
| View PDF | `Ctrl+Alt+V` / `Cmd+Option+V` |
| SyncTeX: PDF → source | `Ctrl+click` in the PDF |
| SyncTeX: source → PDF | `Ctrl+Alt+J` / `Cmd+Option+J` |

#### What `.vscode/settings.json` configures

```json
{
  "latex-workshop.latex.recipe.default": "latexmk",
  "latex-workshop.latex.recipes": [
    { "name": "latexmk", "tools": ["latexmk"] },
    { "name": "xelatex×2", "tools": ["xelatex", "xelatex"] },
    { "name": "xelatex",   "tools": ["xelatex"] }
  ],
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": ["%DOC%"]
    },
    {
      "name": "xelatex",
      "command": "xelatex",
      "args": ["-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%"]
    }
  ],
  "latex-workshop.view.pdf.viewer": "tab",
  "latex-workshop.latex.autoBuild.run": "onSave"
}
```

- **`latexmk`** recipe — the default. Reads `.latexmkrc` (which sets XeLaTeX
  and `TEXINPUTS`), handles multi-pass automatically, and finds `guide.cls`
  from the parent template directory.
- **`xelatex×2`** / **`xelatex`** recipes — available for manual use; note
  these bypass `.latexmkrc` so `TEXINPUTS` must be set separately.
- **`viewer: tab`** — opens the PDF inside VS Code instead of an external app.
- **`autoBuild: onSave`** — recompiles every time you save.

> **pdflatex won't work.** The class loads `fontspec` (system fonts), which
> requires XeLaTeX or LuaLaTeX. The included settings enforce XeLaTeX so you
> don't accidentally use pdflatex.

#### Optional: spell and grammar checking

Install the **LTeX** extension (publisher: *valentjn*) for inline grammar and
spell checking in LaTeX text. It supports both Portuguese and English —
configure it per workspace to match your `guide` language option.

#### Alternative: TeXworks

TeXworks (bundled with MiKTeX on Windows; available with TeX Live on Linux) is
a simpler editor with a built-in PDF preview. Choose it if you prefer a
lightweight single-purpose tool over VS Code.

---

## Requirements

- **Engine:** XeLaTeX **or** LuaLaTeX (required — the template uses `fontspec`).
  `pdflatex` **does not** work.
- **Fonts** (installed on the operating system, not in the LaTeX tree):
  - **Huawei Sans** — body text. If absent, it falls back automatically to
    *Liberation Sans* / *Arial* and emits a warning.
  - **Consolas** — code. If absent, it falls back to *DejaVu Sans Mono*.

  The swap is automatic: the document always compiles, but for full fidelity
  install both fonts.

## How to compile

Each `samples/<lang>/` folder has a `.latexmkrc` that sets `TEXINPUTS=../../`
so `guide.cls` and `assets/` are found from the template root.

**Portuguese** (default):

```bash
cd samples/pt
xelatex main.tex      # run TWICE so the TOC and page numbers are correct
xelatex main.tex
```

**English** (uses the `[english]` class option):

```bash
cd samples/en
xelatex main.tex      # run TWICE so the TOC and page numbers are correct
xelatex main.tex
```

(or `lualatex main.tex`). With `latexmk` (the included `.latexmkrc` sets
XeLaTeX as the default engine, so no `-xelatex` flag is needed):

```bash
cd samples/pt && latexmk main.tex    # Portuguese
cd samples/en && latexmk main.tex    # English
```

`latexmk` needs Perl — see Environment setup above.

---

## Commands and environments

Below are the commands **created by the template** and also standard LaTeX
commands that, in this template, produce a specific look.

### 1. Configuration (preamble)

| Command | What it does |
|---|---|
| `\setguidetitle{...}` | Sets the large **cover** title. |
| `\setheadertitle{...}` | Sets the centered **header** text (repeated on every page). |
| `\setcovertext{...}` | Sets the line below the cover logo (default: `Huawei Technologies CO., LTD`). |
| `\setheaderlogo{path}` | Sets the **header logo** image path (default: `assets/huawei-logo-header.png`). |
| `\setcoverlogo{path}` | Sets the **cover logo** image path (default: `assets/huawei-logo-cover.png`). |
| `\setdocversion{1.0.0}` | Sets the **version** shown on the cover page (e.g. "v1.0.0"). |
| `\setdocdate{2026-08-06}` | Sets the **date** shown on the cover page next to the version. |

Example:

```latex
\setguidetitle{Guia: Salada de frutas}
\setheadertitle{Huawei Cloud -- Guia sobre bananas e maçãs}
\setcovertext{Huawei Technologies CO., LTD}
```

### 2. Document structure

| Command | What it does |
|---|---|
| `\makecover` | Generates the **cover** (title + centered logo + text). Call right after `\begin{document}`. |
| `\sumario` | Generates the **table of contents** ("Sumário" on the right, with a rule and dotted leaders) and page-breaks. |
| `\startbody` | Marks the start of the body and **restarts page numbering at 1**. |

### 3. Headings (automatic numbering 1 / 1.1 / 1.1.1 / 1.1.1.1)

Use the **standard sectioning commands** — the template restyles them with the
Huawei look:

| Command | Result |
|---|---|
| `\section{...}` | **H1**: giant chapter number (72 pt) + 22 pt **bold** right-aligned title + bottom rule. Enters the TOC. |
| `\subsection{...}` | **H2**: 18 pt, regular, left-aligned (e.g. `1.1`). |
| `\subsubsection{...}` | **H3**: 16 pt, regular (e.g. `1.2.1`). |
| `\paragraph{...}` | **H4**: 14 pt, regular (e.g. `1.2.1.1`). |

Starred forms (`\section*{...}`) drop the number and the TOC entry. Each
`\section` starts on a new page.

### 4. Objectives / prerequisites block

The `objetivos` environment groups the chapter's introductory text and **closes
with a 1.5 pt horizontal rule**.

| Command | Result |
|---|---|
| `\begin{objetivos} ... \end{objetivos}` | Opens the block and draws the closing rule. |
| `\objgeral{...}` | **"Objetivo Geral:"** line (bold label) + text. |
| `\objpratica{...}` | **"Objetivo da prática:"** line + text. |
| `\prerequisitos` | **"Pré-requisitos:"** label (use before a list). |
| `\passoapasso` | **"Passo a passo:"** label (use before a numbered list). |

Example:

```latex
\begin{objetivos}
  \objgeral{Lorem ipsum dolor sit amet...}
  \prerequisitos
  \begin{itemize}
    \item Usuário IAM ativo na Huawei Cloud.
    \item Maçã na mão direita.
  \end{itemize}
\end{objetivos}
```

> `\objpratica` and `\passoapasso` also work outside the `objetivos`
> environment (e.g. inside a subsection); see `main.tex`.

### 5. Lists

Use the **standard** `itemize` (bullets) and `enumerate` (numbered) environments
— they already carry the template's indent and spacing.

```latex
\begin{enumerate}
  \item First step.
  \item Second step.
\end{enumerate}
```

### 6. Code

| Command | Result |
|---|---|
| `\begin{codigo} ... \end{codigo}` | **Code block**: `#F6F8FA` background, Consolas 10 pt, `#1F2328` text, left-indented, no border. Content is literal (verbatim). |
| `\begin{codigo}[language] ... \end{codigo}` | Same, passing a language to `listings` (e.g. `[bash]`, `[Python]`). |
| `\codigoarquivo[language]{file}` | Inserts a code block from an **external file**. |
| `\code{...}` | **Inline code** (monospaced) within text. |
| `\param{...}` | File/parameter name in **italic** within text (e.g. `\param{provider.tf}`). |

Example:

```latex
\begin{codigo}
terraform {
  required_providers { ... }
}
\end{codigo}
```

> Inside the `codigo` environment, write code exactly as it should appear;
> `_`, `{`, `}`, `\` etc. are literal (no escaping needed). In running text,
> use `\code{...}` (there, normal LaTeX escaping rules apply).

### 7. Images (always horizontally centered)

| Command | Result |
|---|---|
| `\imagem[width]{file}` | Inserts the image **centered**. `width` is optional (default `0.85\linewidth`). |
| `\imagemc[width]{file}{caption}` | Same, with a **caption** centered below. |

Examples:

```latex
\imagem{assets/tela1.png}
\imagem[0.6\linewidth]{assets/tela2.png}
\imagemc{assets/tela3.png}{Figura 1 -- Tela de login.}
```

### 8. Notes and links

| Command | Result |
|---|---|
| `\nota{...}` | **Observation paragraph in italic**. |
| `\weblink{url}{text}` | Clickable link, **blue, no underline** (`#0000FF`). |
| `\href{url}{text}` | Standard `hyperref` link (also blue via `urlcolor`). |
| `\textbf{...}` | Bold — used to highlight interface terms (e.g. **Console**). |

### 9. Callout boxes

| Environment | Color | Use |
|---|---|---|
| `\begin{aviso} ... \end{aviso}` | Amber | **Warning / caution** — potential pitfalls. |
| `\begin{dica} ... \end{dica}` | Green | **Tip / suggestion** — best practices. |
| `\begin{infobox} ... \end{infobox}` | Blue | **Informational note** — helpful context. |

All boxes have a 3pt left border, light background, and break across pages.

Example:

```latex
\begin{aviso}
The EIP is released when the instance is deleted.
\end{aviso}
```

### 10. Badge

| Command | Result |
|---|---|
| `\badge{...}` | Inline **red label** with white text (e.g. `\badge{Novo}`). |

### 11. Changelog / Versioning

| Command | Result |
|---|---|
| `\setdocversion{1.0.0}` | Shows **v1.0.0** on the cover page. |
| `\setdocdate{2026-08-06}` | Shows the date on the cover page next to the version. |
| `\begin{changelog} ... \end{changelog}` | Version history block, framed with horizontal rules. |
| `\changelogentry{ver}{date}{items}` | One entry: bold version, italic date, bulleted changes. |

Example:

```latex
\setdocversion{1.0.0}
\setdocdate{2026-08-06}

% ... in the document body (typically the last chapter):
\begin{changelog}
  \changelogentry{1.0.0}{2026-08-06}{
    \item Initial version.
    \item Added ECS provisioning.
  }
  \changelogentry{0.9.0}{2025-07-15}{
    \item Draft.
  }
\end{changelog}
```

---

## Format tokens (quick reference)

| Element | Value |
|---|---|
| Page | A4 |
| Margins | top/bottom 3 cm · left/right 2 cm |
| Body font | Huawei Sans, 10.5 pt |
| Code font | Consolas, 10 pt |
| Body leading | ~14 pt |
| Space between paragraphs | 4 pt |
| H1 title | 22 pt bold + 72 pt number + 1.5 pt rule |
| H2 / H3 / H4 titles | 18 / 16 / 14 pt, regular |
| Code background | `#F6F8FA` |
| Code text color | `#1F2328` |
| Link color | `#0000FF` (no underline) |
| Brand red | `#C7000B` (`huaweired` — H1 chapter rules, accents, badge) |
| Warning box | `#FFF8E1` bg / `#F57C00` border |
| Tip box | `#E8F5E9` bg / `#2E7D32` border |
| Info box | `#E3F2FD` bg / `#1565C0` border |

These colors are defined in `guide.cls` (`codebg`, `codetext`, `linkblue`,
`huaweired`) and can be reused with `\textcolor{name}{...}`.

## Class options

```latex
\documentclass[english,indentbody]{guide}
```

- `english` — switches all predefined labels to English (Contents, General
  Objective:, Practice Objective:, Prerequisites:, Step by step:, Page) and
  loads `babel` with the `english` language. Without this option (default),
  labels are in Portuguese and `babel` loads `brazilian`.
- `indentbody` — indents **all running text** by `\contentindent` (0.6 cm),
  reproducing the body indent of the original layout. Without the option
  (default), text is flush to the left margin, aligned with the heading rules.

### Label translations

| Token | Portuguese (default) | English (`[english]`) |
|---|---|---|
| TOC title | Sumário | Contents |
| Cover title default | Guia | Guide |
| `\objgeral` label | Objetivo Geral: | General Objective: |
| `\objpratica` label | Objetivo da prática: | Practice Objective: |
| `\prerequisitos` label | Pré-requisitos: | Prerequisites: |
| `\passoapasso` label | Passo a passo: | Step by step: |
| Header page label | Página | Page |

## Customization

- **Swap the logo:** replace the files in `assets/` keeping the names, or use
  `\setheaderlogo{path}` and `\setcoverlogo{path}` in the preamble.
- **Adjust colors:** edit the `\definecolor` block at the top of `guide.cls`.
- **Adjust sizes/spacing:** each concern is in a commented section of
  `guide.cls` (`TÍTULOS`, `CÓDIGO`, `CABEÇALHO`, etc.) — find the section and
  edit there.
