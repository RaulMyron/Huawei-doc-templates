---
name: labguide
description: Create or edit Huawei Cloud lab guide documents using the LaTeX labguide template. Use when the user wants to write, extend, or fix a lab guide, or asks to create a new document for Huawei Cloud labs. Triggers on keywords like labguide, lab guide, guia de laboratório, Huawei Cloud document.
---

# Skill: Huawei Cloud Lab Guide Creator

This skill helps you create and edit Huawei Cloud lab guide documents using the
`labguide` LaTeX template in this repository.

## Quick start

When the user asks to create a new lab guide:

1. **Ask for the essentials** (if not already provided):
   - **Title** — e.g. "Provisioning an ECS Instance"
   - **Language** — Portuguese (default) or English
   - **Filename** — e.g. `ecs-lab.tex` (defaults to `my-guide.tex`)

2. **Create the file** in `templates/labguide/` using the template structure below.

3. **Compile and verify** with `latexmk <filename>.tex` from the `templates/labguide/` directory.

4. **Report** the page count and any warnings to the user.

## Template location

All template files live in `templates/labguide/`:

```
templates/labguide/
├── labguide.cls      # the class — all formatting lives here
├── main.tex          # Portuguese sample (reference)
├── main_en.tex       # English sample (reference)
├── .latexmkrc        # latexmk config (XeLaTeX by default)
└── assets/           # logos and sample images
```

## Document skeleton

### Portuguese (default)

```latex
\documentclass{labguide}

\setlabtitle{Guia de Laboratório: <topic>}
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

Same skeleton but with `\documentclass[english]{labguide}`. Labels switch
automatically: *Contents*, *General Objective:*, *Practice Objective:*,
*Prerequisites:*, *Step by step:*, *Page*.

## Commands reference

### Preamble configuration
| Command | Purpose |
|---|---|
| `\setlabtitle{...}` | Big cover title. |
| `\setheadertitle{...}` | Centered header text on every page. |
| `\setcovertext{...}` | Line under the cover logo. |
| `\setheaderlogo{path}` | Header logo image path. |
| `\setcoverlogo{path}` | Cover logo image path. |

### Document structure
| Command | Purpose |
|---|---|
| `\makecover` | Render the cover page. |
| `\sumario` | Render the TOC and page-break. |
| `\startbody` | Mark body start; resets page numbering to 1. |

### Headings (automatic numbering: 1 / 1.1 / 1.1.1 / 1.1.1.1)
| Command | Result |
|---|---|
| `\section{...}` | H1: giant 72pt chapter number + 22pt bold title + red rule. New page. |
| `\subsection{...}` | H2: 18pt regular. |
| `\subsubsection{...}` | H3: 16pt regular. |
| `\paragraph{...}` | H4: 14pt regular. |

### Objectives block
```latex
\begin{objetivos}
  \objgeral{<text>}
  \objpratica{<text>}
  \prerequisitos
  \begin{itemize}
    \item ...
  \end{itemize}
\end{objetivos}
```
Closes with a 1.5pt horizontal rule. `\objpratica` and `\passoapasso` also
work outside the environment.

### Code
| Command | Result |
|---|---|
| `\begin{codigo} ... \end{codigo}` | Code block (verbatim, `#F6F8FA` bg). No escaping needed. |
| `\begin{codigo}[bash] ... \end{codigo}` | Same, with syntax highlighting. |
| `\codigoarquivo[lang]{file}` | Code block from an external file. |
| `\code{...}` | Inline monospace code (standard LaTeX escaping applies). |
| `\param{...}` | Filename/parameter in italic. |

### Images (always centered)
| Command | Result |
|---|---|
| `\imagem{file}` | Centered image, default width `0.85\linewidth`. |
| `\imagem[0.6\linewidth]{file}` | Custom width. |
| `\imagemc{file}{caption}` | With centered caption below. |

### Notes and links
| Command | Result |
|---|---|
| `\nota{...}` | Italic observation paragraph. |
| `\weblink{url}{text}` | Blue clickable link, no underline. |
| `\textbf{...}` | Bold for UI terms. |

## Class options

```latex
\documentclass[english,indentbody]{labguide}
```
- `english` — English labels + babel english. Default: Portuguese.
- `indentbody` — indent all running text by 0.6cm. Default: off.

## Compilation

```bash
cd templates/labguide
latexmk <filename>.tex        # uses .latexmkrc → xelatex, auto two-pass
```

Or manually:
```bash
xelatex <filename>.tex && xelatex <filename>.tex   # two passes for TOC
```

**Never use pdflatex** — the class loads `fontspec` which requires XeLaTeX.

## Rules

1. Content goes in `.tex` files; look-and-feel goes in `labguide.cls`.
2. Inside `codigo`, write literal code — no escaping.
3. In prose, use `\code{...}` with normal LaTeX escaping.
4. Each `\section` starts on a new page.
5. After creating a document, compile with `latexmk` and verify the PDF.
6. If a font is missing, the class warns and falls back — the build still succeeds.
