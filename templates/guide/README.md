# Huawei Cloud Guide — LaTeX Template

A LaTeX template that produces a Huawei Cloud guide PDF: cover page, header,
table of contents, giant chapter numbers, objectives box, code blocks,
callout boxes, badges, colors, spacing, and fonts.

> **Setup:** see the [root README](../../README.md) for installation,
> environment setup, VS Code configuration, and compilation instructions.
> See [SKILL.md](SKILL.md) for the full command and environment reference.

## Language

By default the guide renders in **Portuguese** — the class loads `babel` with
the `brazilian` language and built-in labels such as *Sumário*,
*Objetivo Geral:*, *Objetivo:*, *Pré-requisitos:* and *Passo a passo:* are in
Portuguese. Pass the **`english`** class option
(`\documentclass[english]{guide}`) to switch all labels to English and load
`babel` with `english` instead.

## Class options

```latex
\documentclass[english,indentbody,notime]{guide}
```

| Option | Effect |
|---|---|
| `english` | Switches all predefined labels to English; loads `babel` with `english`. Default off (Portuguese / `brazilian`). |
| `indentbody` | Indents all running text by `\contentindent` (0.6 cm). Default off (text flush to the left margin). |
| `notime` | Hides the compilation time (HH:MM) on the cover page. Default off (time is shown). |

### Label translations

| Token | Portuguese (default) | English (`[english]`) |
|---|---|---|
| TOC title | Sumário | Contents |
| Cover title default | Guia | Guide |
| `\objgeral` label | Objetivo Geral: | General Objective: |
| `\objpratica` label | Objetivo: | Objective: |
| `\prerequisitos` label | Pré-requisitos: | Prerequisites: |
| `\passoapasso` label | Passo a passo: | Step by step: |
| Footer page label | Página | Page |

## Document structure

The body order is fixed: `\makecover` → `\sumario` → `\startbody` → sections.

```latex
\documentclass{guide}          % or [english] for English

\setguidetitle{Guia: <topic>}
\setheadertitle{Huawei Cloud -- <short title>}
\setdocversion{1.0.0}

\begin{document}
\makecover
\sumario
\startbody

\section{<chapter title>}
% ... content ...

\end{document}
```

See [SKILL.md](SKILL.md) for the complete skeleton and all available commands
and environments (`\objgeral`, `\prerequisitos`, `\passoapasso`, `codigo`,
`\imagem`, `\menu`, `\badge`, `changelog`, callout boxes, etc.).

## Format reference

| Element | Value |
|---|---|
| Page | A4 |
| Margins | top/bottom 3 cm · left/right 2 cm |
| Body font | HarmonyOS Sans, 10.5 pt |
| Code font | Cascadia Code, 10 pt |
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

Colors are defined in `guide.cls` and reusable via `\textcolor{name}{...}`.

## Customization

- **Logos:** replace files in `assets/` keeping the names, or use
  `\setheaderlogo{path}` / `\setcoverlogo{path}` in the preamble.
- **Colors:** edit the `\definecolor` block at the top of `guide.cls`.
- **Sizes/spacing:** each concern is in a commented section of `guide.cls`
  (`TÍTULOS`, `CÓDIGO`, `CABEÇALHO`, etc.) — find the section and edit there.

## Samples

Two samples demonstrate all commands and environments:

- [`examples/guide/pt/main.tex`](../../examples/guide/pt/main.tex) — Portuguese
- [`examples/guide/en/main.tex`](../../examples/guide/en/main.tex) — English

Compile with `latexmk main.tex` from either folder.
