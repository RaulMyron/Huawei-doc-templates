# Huawei Document Templates

A collection of LaTeX templates for Huawei documents. Each template is a
self-contained directory under `templates/` — compile with XeLaTeX.

## Quick start

```bash
git clone <repo-url> Huawei-doc-templates
cd Huawei-doc-templates
./install.sh          # installs XeLaTeX, latexmk, fonts (Ubuntu/Debian)
```

Then open the project in [opencode](https://opencode.ai) and run:

```
/skill labguide
```

to create a new lab guide document. The skill guides you through title,
language, and content, then compiles and verifies the PDF.

## Manual usage

If you prefer to work without opencode:

```bash
cd templates/labguide
latexmk main.tex        # Portuguese sample (uses .latexmkrc → xelatex)
latexmk main_en.tex     # English sample
```

Or with raw XeLaTeX (run twice for the TOC):

```bash
cd templates/labguide
xelatex main.tex && xelatex main.tex
```

See the template's own [`README.md`](templates/labguide/README.md) for its
commands, environments, and options.

## Templates

| Template | Description |
|---|---|
| [`labguide`](templates/labguide/) | Huawei Cloud lab guide — branded cover, header, TOC, giant chapter numbers, objectives block, code blocks. Supports Portuguese (default) and English via the `[english]` class option. |

## Requirements

- **OS:** Ubuntu/Debian (WSL or native). `install.sh` handles everything.
- **Engine:** XeLaTeX or LuaLaTeX. The templates use `fontspec`, so `pdflatex`
  will **not** work.
- **Fonts:** loaded from the operating system, not the LaTeX tree. Each
  template falls back gracefully (with a warning) if a brand font is missing —
  the document still compiles. See each template's README for its fonts.
- **opencode** (optional): for the `/skill labguide` workflow.

## Project layout

```
.
├── install.sh               # one-command setup (Ubuntu/Debian)
├── README.md                # this file (collection index)
├── LICENSE                  # MIT
├── .vscode/
│   └── settings.json        # VS Code + LaTeX Workshop config (XeLaTeX recipe)
├── .opencode/
│   └── skills/
│       └── labguide/
│           └── SKILL.md     # opencode skill — /skill labguide to create documents
└── templates/
    └── labguide/            # one self-contained template per directory
        ├── README.md        # template-specific human docs
        ├── SKILL.md         # template-specific agent orientation
        ├── labguide.cls     # the class — all formatting lives here
        ├── main.tex         # sample document in Portuguese
        ├── main_en.tex      # sample document in English
        ├── .latexmkrc       # latexmk config (XeLaTeX by default)
        ├── .vscode/
        │   └── settings.json  # same XeLaTeX config (for opening this subfolder)
        └── assets/          # logos and sample images
```

## License

MIT — see [LICENSE](LICENSE).
