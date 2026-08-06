---
name: huawei-template-guide
description: Create or edit Huawei Cloud guide documents using the LaTeX guide template. Use when the user wants to write, extend, or fix a guide, or asks to create a new document for Huawei Cloud. Triggers on keywords like huawei-template-guide, huawei guide, guia huawei, Huawei Cloud document.
---

# Huawei Cloud Guide — Skill

Create, edit, and compile Huawei Cloud guide documents using the
`guide` LaTeX class in this directory.

## When to use

Use this skill when the task is to **write, extend, or fix a Huawei Cloud
guide**. The output is a PDF compiled from LaTeX. Content defaults to
Portuguese ("Guia"); pass the `english` class option for English
labels. Do **not** use this for general LaTeX documents — the formatting is
hard-coded to the Huawei house style.

---

## Quick start — creating a new document

1. **Ask for the essentials** (if not already provided):
   - **Title** — e.g. "Provisioning an ECS Instance"
   - **Language** — Portuguese (default) or English
   - **Project name** — used as the folder name (e.g. `ecs-provisioning`)
   - **Location** — where to create the project folder (default: current
     workspace). The skill should ask the user; do not assume `samples/`.

2. **Create a self-contained project folder** at `<location>/<project-name>/`:
   - **Always create a folder** — never scatter files directly in the workspace.
   - Inside the folder, create:
     - `<filename>.tex` — the document, using the skeleton below.
     - `.latexmkrc` — with `TEXINPUTS` pointing to this template directory
       (`templates/guide/`). Compute the relative path from the project folder
       to `templates/guide/` and set:
       ```perl
       $ENV{TEXINPUTS} = "<relative_path>:" . ($ENV{TEXINPUTS} || "");
       $pdf_mode = 5;
       $xelatex = 'xelatex -interaction=nonstopmode %O %S';
       ```
       For example, if the project is at `setup-guide/` in the repo root,
       the path is `../templates/guide/`. If inside `samples/pt/`, use `../../`.
   - Any project-specific assets (images, code files) also go in this folder.

3. **Compile and verify** with `latexmk <filename>.tex` from inside the
   project folder.

4. **Report** the page count and any warnings to the user.

---

## Hard requirements

- **Engine: XeLaTeX or LuaLaTeX only.** The class loads `fontspec`, so
  `pdflatex` will fail. Always compile with `xelatex` (or `lualatex`).
- **Compile twice** on the first run so the TOC and page numbers settle.
  `latexmk` handles this automatically (`.latexmkrc` is included).
- **Fonts** are loaded from the OS, not the LaTeX tree:
  - *Huawei Sans* (body text) — falls back to Liberation Sans → Arial.
  - *Consolas* (code) — falls back to DejaVu Sans Mono.
  The document always compiles; missing fonts only reduce fidelity.

---

## Project layout (this directory)

```
.
├── guide.cls          # the class — ALL formatting lives here
├── README.md           # human docs
├── SKILL.md            # this file (opencode skill)
├── .latexmkrc          # latexmk config (XeLaTeX by default)
├── assets/
│   ├── huawei-logo-header.png   # header logo
│   ├── huawei-logo-cover.png    # cover logo
│   ├── exemplo-menu.png         # sample image
│   └── exemplo-login.png        # sample image
└── samples/            # self-contained project folders by language
    ├── pt/
    │   ├── .latexmkrc  # TEXINPUTS=../../ so guide.cls is found
    │   └── main.tex    # Portuguese sample (reference)
    └── en/
        ├── .latexmkrc
        └── main.tex    # English sample (reference)
```

**Rule of thumb:** content/structure goes in `.tex` files; look-and-feel goes
in `guide.cls`. Do not inline formatting overrides in the document unless
the user asks.

---

## Document skeleton

### Portuguese (default)

```latex
\documentclass{guide}

\setguidetitle{Guia: <topic>}
\setheadertitle{Huawei Cloud -- <short title>}
\setcovertext{Huawei Technologies CO., LTD}

\begin{document}
\makecover
\sumario
\startbody

\section{<chapter title>}

\begin{objetivos}
  \objgeral{<general objective>}
  \prerequisitos
  \begin{itemize}
    \item <prerequisite 1>
    \item <prerequisite 2>
  \end{itemize}
\end{objetivos}

\subsection{<section title>}
\objpratica{<practice objective>}

\passoapasso
\begin{enumerate}
  \item <step 1>
  \item <step 2>
\end{enumerate}

\end{document}
```

### English

Same skeleton but with `\documentclass[english]{guide}`. Labels switch
automatically: *Contents*, *General Objective:*, *Practice Objective:*,
*Prerequisites:*, *Step by step:*, *Page*.

Body order is fixed: `\makecover` → `\sumario` → `\startbody` → sections.

---

---

## Commands reference

### Preamble configuration
| Command | Purpose |
|---|---|
| `\setguidetitle{...}` | Big cover title. |
| `\setheadertitle{...}` | Centered header text on every page. |
| `\setcovertext{...}` | Line under the cover logo (default `Huawei Technologies CO., LTD`). |
| `\setheaderlogo{path}` | Header logo image path (default `assets/huawei-logo-header.png`). |
| `\setcoverlogo{path}` | Cover logo image path (default `assets/huawei-logo-cover.png`). |
| `\setdocversion{1.0.0}` | Document version, shown on the cover page (e.g. "v1.0.0"). |
| `\setdocdate{2025-08-06}` | Document date, shown on the cover page next to the version. |+| ### Document structure
| Command | Purpose |
|---|---|
| `\makecover` | Render the cover. Call right after `\begin{document}`. |
| `\sumario` | Render the TOC ("Sumário" / "Contents", right-aligned, dotted leaders) and page-break. |
| `\startbody` | Mark body start; **resets page numbering to 1**. |

### Headings — use standard section commands (template restyles them)
| Command | Result |
|---|---|
| `\section{...}` | H1: giant 72pt chapter number + 22pt bold right-aligned title + red rule. New page. In TOC. |
| `\subsection{...}` | H2: 18pt regular, left-aligned (`1.1`). |
| `\subsubsection{...}` | H3: 16pt regular (`1.1.1`). |
| `\paragraph{...}` | H4: 14pt regular (`1.1.1.1`). |

Starred forms (`\section*{...}`) drop the number and the TOC entry.
**Note:** `\section*` also triggers `\clearpage` (every H1 starts on a new
page, including unnumbered ones).
Numbering is automatic: `1` / `1.1` / `1.1.1` / `1.1.1.1`.

### Objectives / prerequisites block
```latex
\begin{objetivos}
  \objgeral{<general objective>}
  \objpratica{<practice objective>}
  \prerequisitos
  \begin{itemize}
    \item ...
  \end{itemize}
\end{objetivos}
```
Closes with a 1.5pt horizontal rule. `\objpratica` and `\passoapasso` also
work outside `objetivos` (e.g. inside a subsection).

| Command | Produces |
|---|---|
| `\objgeral{...}` | **"Objetivo Geral:"** / **"General Objective:"** (bold label) + text. |
| `\objpratica{...}` | **"Objetivo da prática:"** / **"Practice Objective:"** + text. |
| `\prerequisitos` | **"Pré-requisitos:"** / **"Prerequisites:"** label (put a list after). |
| `\passoapasso` | **"Passo a passo:"** / **"Step by step:"** label (put a numbered list after). |

### Lists
Use standard `itemize` / `enumerate` — indent and spacing are already set by the
class. Do not pass `enumitem` options unless asked.

### Code
| Command | Result |
|---|---|
| `\begin{codigo} ... \end{codigo}` | Code block: `#F6F8FA` bg, Consolas 10pt, `#1F2328` text, left-indented, no border. **Verbatim** — `_{}^\` are literal, no escaping. |
| `\begin{codigo}[bash] ... \end{codigo}` | Same, with `listings` language hint (`bash`, `Python`, …). |
| `\codigoarquivo[linguagem]{arquivo}` | Code block from an external file. |
| `\code{...}` | Inline monospace code. **Standard LaTeX escaping rules apply** here. |
| `\param{...}` | Filename/parameter in italic (e.g. `\param{provider.tf}`). |

**Gotcha:** inside `codigo`, write code literally — no escaping. In running text
use `\code{...}` and escape LaTeX specials normally.

### Images (always horizontally centered)
| Command | Result |
|---|---|
| `\imagem{file}` | Centered image, default width `0.85\linewidth`. |
| `\imagem[0.6\linewidth]{file}` | Centered image, custom width. |
| `\imagemc{file}{caption}` | Centered image with centered caption below. |
| `\imagemc[0.6\linewidth]{file}{caption}` | With custom width. |

### Notes & links
| Command | Result |
|---|---|
| `\nota{...}` | Italic observation paragraph. |
| `\weblink{url}{text}` | Blue (`#0000FF`), no underline, clickable. |
| `\href{url}{text}` | Standard `hyperref` link (also blue via `urlcolor`). |
| `\textbf{...}` | Bold — use for UI terms (e.g. **Console**). |

### Callout boxes
| Environment | Color | Use |
|---|---|---|
| `\begin{aviso} ... \end{aviso}` | Amber (`#FFF8E1` bg, `#F57C00` border) | Warning / caution — potential pitfalls. |
| `\begin{dica} ... \end{dica}` | Green (`#E8F5E9` bg, `#2E7D32` border) | Tip / suggestion — best practices. |
| `\begin{infobox} ... \end{infobox}` | Blue (`#E3F2FD` bg, `#1565C0` border) | Informational note — helpful context. |

All boxes are breakable across pages and have a 3pt left border.

### Badge
| Command | Result |
|---|---|
| `\badge{...}` | Inline red label with white text (e.g. `\badge{Novo}`). |

### Changelog / Versioning
| Command | Purpose |
|---|---|
| `\setdocversion{1.0.0}` | Sets the version shown on the cover page. |
| `\setdocdate{2025-08-06}` | Sets the date shown on the cover page. |
| `\begin{changelog} ... \end{changelog}` | Version history block (framed with horizontal rules). |
| `\changelogentry{version}{date}{items}` | One entry inside `changelog`. `items` is an `itemize` body. |

Example:

```latex
\begin{changelog}
  \changelogentry{1.0.0}{2025-08-06}{
    \item Initial version.
    \item Added ECS provisioning.
  }
  \changelogentry{0.9.0}{2025-07-15}{
    \item Draft.
  }
\end{changelog}
```

---

## Class options

```latex
\documentclass[english,indentbody]{guide}
```
- `english` — switches all predefined labels to English and loads `babel` with
  `english`. Default off (Portuguese / `brazilian`).
- `indentbody` — indents all running text by `\contentindent` (0.6cm). Default
  off (text flush to the left margin).

---

## Colors (defined in `guide.cls`, reusable via `\textcolor{name}{...}`)
| Name | Hex | Use |
|---|---|---|
| `codebg` | `#F6F8FA` | Code block background |
| `codetext` | `#1F2328` | Code text |
| `linkblue` | `#0000FF` | Links |
| `huaweired` | `#C7000B` | Brand red (H1 chapter rules, accents, badge) |
| `ruleblack` | `#000000` | Horizontal rules (TOC, objectives) |
| `warningbg` | `#FFF8E1` | Warning box background |
| `warningfg` | `#F57C00` | Warning box border |
| `tipbg` | `#E8F5E9` | Tip box background |
| `tipfg` | `#2E7D32` | Tip box border |
| `infobg` | `#E3F2FD` | Info box background |
| `infofg` | `#1565C0` | Info box border |

---

## Format reference
- Page: A4 · margins top/bottom 3cm, left/right 2cm.
- Body: Huawei Sans 10.5pt, ~14pt leading, 4pt between paragraphs, no first-line
  indent, `\frenchspacing`.
- H1: 22pt bold + 72pt chapter number + 1.5pt red rule. H2/H3/H4: 18/16/14pt regular.
- Code: Consolas 10pt on `#F6F8FA`.
- Links: `#0000FF`, no underline.

---

## Compilation

From the project folder (wherever the user chose to create it):

```bash
latexmk main.tex             # uses .latexmkrc → xelatex, auto two-pass
```

Or manually:
```bash
xelatex main.tex && xelatex main.tex   # two passes for TOC
```

**Never use pdflatex** — the class loads `fontspec` which requires XeLaTeX.

The project's `.latexmkrc` sets `TEXINPUTS` to the template directory so
`guide.cls` and `assets/` are found. The existing `samples/pt/` and
`samples/en/` folders are pre-configured examples.

---

## Customization pointers (when the user asks to change the look)
- **Logos:** replace files in `assets/` keeping the names, or use
  `\setheaderlogo{path}` / `\setcoverlogo{path}` in the preamble.
- **Colors:** edit the `\definecolor` block at the top of `guide.cls`.
- **Sizes/spacing:** each concern is in a commented section of
  `guide.cls` (`TÍTULOS`, `CÓDIGO`, `CABEÇALHO`, etc.) — find the section,
  edit there.

---

## Agent workflow checklist
1. Confirm the engine: never run `pdflatex`. Use `xelatex` (twice) or
   `latexmk` (handles it via `.latexmkrc`).
2. Edit `.tex` files for content; touch `guide.cls` only for look-and-feel
   changes the user explicitly requested.
3. Keep body order: `\makecover` → `\sumario` → `\startbody` → sections.
4. Inside `codigo`, write literal code. In prose, use `\code{...}` with normal
   escaping.
5. After edits, compile and check the PDF (TOC + page numbers need the
   second pass).
6. If a font is missing, the class warns and falls back — the build still
   succeeds; surface the warning to the user but do not block.
