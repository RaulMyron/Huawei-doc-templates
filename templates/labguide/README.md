# Huawei Cloud Lab Guide — LaTeX Template

A LaTeX template that produces a Huawei Cloud lab guide PDF: cover page, header,
table of contents, giant chapter numbers, objectives box, code blocks, colors,
spacing, and fonts.

> **Language note:** the lab guide content is written in **Portuguese** and the
> class loads `babel` with the `brazilian` language (`labguide.cls`), so built-in
> labels such as *Sumário*, *Objetivo Geral:*, *Objetivo da prática:*,
> *Pré-requisitos:* and *Passo a passo:* render in Portuguese by design.

## Project structure

```
.
├── labguide.cls      # the class — all formatting lives here
├── main.tex          # sample document / starting point
├── README.md         # this file (human guide)
├── SKILL.md          # agent orientation
└── assets/
    ├── huawei-logo-header.png   # header logo
    ├── huawei-logo-cover.png    # cover logo
    ├── exemplo-menu.png         # sample image
    └── exemplo-login.png        # sample image
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

4. **Compile** — in the template folder:
   ```
   xelatex main.tex
   xelatex main.tex
   ```
   Run **twice** so the TOC and page numbers settle. Or automate with
   `latexmk -xelatex main.tex` (Perl is preinstalled on Linux, so `latexmk`
   works once the package above is installed).

5. **Missing packages** — install the relevant `texlive-*` package via your
   package manager, or fall back to `texlive-full` / `texlive-scheme-full`.

### Code editor (optional, both OSes)

Use TeXworks (bundled with MiKTeX on Windows; available with TeX Live on Linux)
or install [VS Code](https://code.visualstudio.com/) with the **LaTeX Workshop**
extension — it compiles with one click and previews the PDF side by side.

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

```bash
xelatex main.tex      # run TWICE so the TOC and page numbers are correct
xelatex main.tex
```

(or `lualatex main.tex`). With `latexmk`:

```bash
latexmk -xelatex main.tex
```

`latexmk` needs Perl — see Environment setup above.

---

## Commands and environments

Below are the commands **created by the template** and also standard LaTeX
commands that, in this template, produce a specific look.

### 1. Configuration (preamble)

| Command | What it does |
|---|---|
| `\setlabtitle{...}` | Sets the large **cover** title. |
| `\setheadertitle{...}` | Sets the centered **header** text (repeated on every page). |
| `\setcovertext{...}` | Sets the line below the cover logo (default: `Huawei Technologies CO., LTD`). |
| `\setheaderlogo{path}` | Sets the **header logo** image path (default: `assets/huawei-logo-header.png`). |
| `\setcoverlogo{path}` | Sets the **cover logo** image path (default: `assets/huawei-logo-cover.png`). |

Example:

```latex
\setlabtitle{Guia de Laboratório: Salada de frutas}
\setheadertitle{Huawei Cloud -- Guia do laboratório sobre bananas e maçãs}
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
| Brand red | `#C7000B` (`huaweired` — H1 chapter rules & accents) |

These colors are defined in `labguide.cls` (`codebg`, `codetext`, `linkblue`,
`huaweired`) and can be reused with `\textcolor{name}{...}`.

## Class options

```latex
\documentclass[indentbody]{labguide}
```

- `indentbody` — indents **all running text** by `\contentindent` (0.6 cm),
  reproducing the body indent of the original layout. Without the option
  (default), text is flush to the left margin, aligned with the heading rules.

## Customization

- **Swap the logo:** replace the files in `assets/` keeping the names, or use
  `\setheaderlogo{path}` and `\setcoverlogo{path}` in the preamble.
- **Adjust colors:** edit the `\definecolor` block at the top of `labguide.cls`.
- **Adjust sizes/spacing:** each concern is in a commented section of
  `labguide.cls` (`TÍTULOS`, `CÓDIGO`, `CABEÇALHO`, etc.) — find the section and
  edit there.
