# SKILL.md — Huawei Cloud Lab Guide Template

This is a LaTeX template for Huawei Cloud lab guides
("Guia de Laboratório"). Use it to author lab guides that match the
Huawei house style: branded cover, header, table of contents, giant chapter
numbers, objectives box, code blocks, colors, fonts.

This file is the orientation for **AI agents**. For the human-facing README, see
`README.md`.

---

## When to use

Use this project when the task is to **write, extend, or fix a Huawei Cloud lab
guide** (Portuguese, "Guia de Laboratório"). The output is a PDF compiled from
LaTeX. Do **not** use this for general LaTeX documents — the formatting is
hard-coded to the Huawei house style.

---

## Hard requirements (do not violate)

- **Engine: XeLaTeX or LuaLaTeX only.** The class loads `fontspec`, so
  `pdflatex` will fail. Always compile with `xelatex` (or `lualatex`).
- **Compile twice** on the first run so the TOC and page numbers settle:
  `xelatex main.tex && xelatex main.tex`. (Or `latexmk -xelatex main.tex`.)
- **Fonts** are loaded from the OS, not the LaTeX tree:
  - *Huawei Sans* (body text) — falls back to Liberation Sans → Arial with a
    warning if missing.
  - *Consolas* (code) — falls back to DejaVu Sans Mono if missing.
  The document always compiles; missing fonts only reduce fidelity.

---

## Project layout

```
.
├── labguide.cls      # the class — ALL formatting lives here
├── main.tex          # example document / starting point
├── README.md         # human docs
├── SKILL.md          # this file (agent orientation)
└── assets/
    ├── huawei-logo-header.png   # header logo
    ├── huawei-logo-cover.png    # cover logo
    ├── exemplo-menu.png         # sample image
    └── exemplo-login.png        # sample image
```

**Rule of thumb:** content/structure goes in `main.tex` (or a new `.tex` that
`\input`s it); look-and-feel goes in `labguide.cls`. Do not inline formatting
overrides in the document unless the user asks.

---

## How to author a guide

1. Copy `main.tex` as a starting point (or edit it in place).
2. In the preamble, set the three configuration commands:
   ```latex
   \setlabtitle{Guia de Laboratório: <topic>}
   \setheadertitle{Huawei Cloud -- <short title>}
   \setcovertext{Huawei Technologies CO., LTD}
   ```
3. Body order is fixed:
   ```latex
   \begin{document}
   \makecover        % cover page
   \sumario          % table of contents (+ page break)
   \startbody        % restarts page numbering at 1
   \section{...}     % chapters start here
   ...
   \end{document}
   ```
4. Write content with the commands/environments listed below.

---

## Commands & environments (the API the agent should use)

### Preamble config
| Command | Purpose |
|---|---|
| `\setlabtitle{...}` | Big cover title. |
| `\setheadertitle{...}` | Centered header text on every page. |
| `\setcovertext{...}` | Line under the cover logo (default `Huawei Technologies CO., LTD`). |

### Document structure
| Command | Purpose |
|---|---|
| `\makecover` | Render the cover. Call right after `\begin{document}`. |
| `\sumario` | Render the TOC ("Sumário", right-aligned, dotted leaders) and page-break. |
| `\startbody` | Mark body start; **resets page numbering to 1**. |

### Headings — use standard section commands (template restyles them)
| Command | Result |
|---|---|
| `\section{...}` | H1: giant 72pt chapter number + 22pt bold right-aligned title + bottom rule. In TOC. |
| `\subsection{...}` | H2: 18pt regular, left-aligned (`1.1`). |
| `\subsubsection{...}` | H3: 16pt regular (`1.1.1`). |
| `\paragraph{...}` | H4: 14pt regular (`1.1.1.1`). |

Starred forms (`\section*{...}`) drop the number and the TOC entry.
Numbering is automatic: `1` / `1.1` / `1.1.1` / `1.1.1.1`.

### Objectives / prerequisites block
```latex
\begin{objetivos}
  \objgeral{<general objective text>}
  \objpratica{<practice objective text>}
  \prerequisitos
  \begin{itemize}
    \item ...
  \end{itemize}
\end{objetivos}
```
The environment closes with a 1.5pt horizontal rule.
`\objpratica` and `\passoapasso` also work outside `objetivos` (e.g. inside a
subsection).

| Command | Produces |
|---|---|
| `\objgeral{...}` | **"Objetivo Geral:"** (bold label) + text. |
| `\objpratica{...}` | **"Objetivo da prática:"** + text. |
| `\prerequisitos` | **"Pré-requisitos:"** label (put a list after). |
| `\passoapasso` | **"Passo a passo:"** label (put a numbered list after). |

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

---

## Class options

```latex
\documentclass[indentbody]{labguide}
```
- `indentbody` — indents all running text by `\contentindent` (0.6cm). Default off (text flush to the left margin).

---

## Colors (defined in `labguide.cls`, reusable via `\textcolor{name}{...}`)
| Name | Hex | Use |
|---|---|---|
| `codebg` | `#F6F8FA` | Code block background |
| `codetext` | `#1F2328` | Code text |
| `linkblue` | `#0000FF` | Links |
| `huaweired` | `#C7000B` | Brand red (accents) |
| `rulegray` | `#000000` | Horizontal rules |

---

## Format reference
- Page: A4 · margins top/bottom 3cm, left/right 2cm.
- Body: Huawei Sans 10.5pt, ~14pt leading, 4pt between paragraphs, no first-line
  indent, `\frenchspacing`.
- H1: 22pt bold + 72pt chapter number + 1.5pt rule. H2/H3/H4: 18/16/14pt regular.
- Code: Consolas 10pt on `#F6F8FA`.
- Links: `#0000FF`, no underline.

---

## Customization pointers (when the user asks to change the look)
- **Logos:** replace files in `assets/` keeping the names, or edit the
  `\includegraphics` paths in `labguide.cls` (cover + header sections).
- **Colors:** edit the `\definecolor` block at the top of `labguide.cls`.
- **Sizes/spacing:** each concern is in a commented section of `labguide.cls`
  (`TÍTULOS`, `CÓDIGO`, `CABEÇALHO`, etc.) — find the section, edit there.

---

## Agent workflow checklist
1. Confirm the engine: never run `pdflatex`. Use `xelatex` (twice) or
   `latexmk -xelatex`.
2. Edit `main.tex` for content; touch `labguide.cls` only for look-and-feel
   changes the user explicitly requested.
3. Keep body order: `\makecover` → `\sumario` → `\startbody` → sections.
4. Inside `codigo`, write literal code. In prose, use `\code{...}` with normal
   escaping.
5. After edits, compile twice and check the PDF (TOC + page numbers need the
   second pass).
6. If a font is missing, the class warns and falls back — the build still
   succeeds; surface the warning to the user but do not block.
