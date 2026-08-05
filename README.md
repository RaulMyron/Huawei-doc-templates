# Huawei Document Templates

A collection of LaTeX templates for Huawei documents. Each template is a
self-contained directory under `templates/` — copy the folder you need and
compile with XeLaTeX.

## Templates

| Template | Description |
|---|---|
| [`labguide`](templates/labguide/) | Huawei Cloud lab guide (*Guia de Laboratório*) — branded cover, header, table of contents, giant chapter numbers, objectives block, code blocks. Content in Portuguese. |

## Usage

Each template folder is independent. Pick one, enter it, and compile:

```bash
cd templates/labguide
xelatex main.tex      # run twice so the TOC and page numbers settle
xelatex main.tex
```

See the template's own `README.md` for its commands, environments, and options.

## Requirements

- **Engine:** XeLaTeX or LuaLaTeX. The templates use `fontspec`, so `pdflatex`
  will **not** work.
- **Fonts:** loaded from the operating system, not the LaTeX tree. Each
  template falls back gracefully (with a warning) if a brand font is missing —
  the document still compiles. See each template's README for its fonts.

## Project layout

```
.
├── README.md                # this file (collection index)
├── LICENSE                  # MIT
└── templates/
    └── labguide/            # one self-contained template per directory
        ├── README.md        # template-specific human docs
        ├── SKILL.md         # template-specific agent orientation
        ├── labguide.cls     # the class — all formatting lives here
        ├── main.tex         # sample document / starting point
        └── assets/          # logos and sample images
```

## License

MIT — see [LICENSE](LICENSE).
