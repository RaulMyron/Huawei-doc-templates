# Huawei Document Templates

A collection of LaTeX templates for Huawei documents. Each template is a
self-contained directory under `templates/` with its own class, samples,
skill, and build config. Compile with XeLaTeX.

## Quick start

```bash
git clone <repo-url> Huawei-doc-templates
cd Huawei-doc-templates
./install.sh          # installs XeLaTeX, latexmk, fonts, opencode skills, VS Code extension
```

Then open the project in [opencode](https://opencode.ai) and run:

```
/skill huawei-template-guide
```

to create a new guide document. The skill guides you through title,
language, and content, then compiles and verifies the PDF.

## How it works

- **`install.sh`** installs the base: XeLaTeX, latexmk, LaTeX packages, fallback
  fonts, VS Code extensions, and copies each template's skill to the global
  opencode path (`~/.config/opencode/skills/`).
- **`opencode.json`** registers `templates/` as a skill discovery path, so
  OpenCode finds each template's `SKILL.md` automatically — **no need to run
  `install.sh`** for project-level skill discovery. The global install is only
  needed when working outside this repo.
- **Each template** in `templates/<name>/` is self-contained: class file,
  samples, skill, build config, assets. Add a new template by creating a new
  directory with a `SKILL.md` — it's auto-discovered.

## Manual usage

```bash
cd templates/guide/samples/pt && latexmk main.tex   # Portuguese
cd templates/guide/samples/en && latexmk main.tex   # English
```

Or with raw XeLaTeX (run twice for the TOC):

```bash
cd templates/guide/samples/pt
xelatex main.tex && xelatex main.tex
```

See the template's own [`README.md`](templates/guide/README.md) for its
commands, environments, and options.

## Templates

| Template | Skill | Description |
|---|---|---|
| [`guide`](templates/guide/) | `/skill huawei-template-guide` | Huawei Cloud guide — branded cover, header, TOC, giant chapter numbers, objectives block, code blocks, callout boxes, badges. Portuguese (default) and English. |

## Requirements

- **OS:** Ubuntu/Debian (WSL or native). `install.sh` handles everything.
- **Engine:** XeLaTeX or LuaLaTeX. The templates use `fontspec`, so `pdflatex`
  will **not** work.
- **Fonts:** loaded from the operating system, not the LaTeX tree. Each
  template falls back gracefully (with a warning) if a brand font is missing —
  the document still compiles. See each template's README for its fonts.
- **opencode** (optional): for the `/skill <name>` workflow.

## Project layout

```
.
├── AGENTS.md               # project standards and locked decisions
├── install.sh               # one-command setup (base deps + skills + VS Code)
├── opencode.json            # skill discovery: scans templates/ for SKILL.md
├── README.md                # this file (collection index)
├── LICENSE                  # MIT
├── .vscode/
│   └── settings.json        # VS Code + LaTeX Workshop config (latexmk recipe)
├── templates/
│   └── guide/               # self-contained template + skill
│       ├── SKILL.md          # opencode skill (/skill huawei-template-guide) + agent reference
│       ├── README.md         # human docs
│       ├── guide.cls         # the class — all formatting lives here
│       ├── .latexmkrc        # latexmk config (XeLaTeX, TZ=America/Sao_Paulo)
│       ├── assets/           # logos and sample images
│       └── samples/          # self-contained project folders by language
│           ├── pt/
│           │   ├── .latexmkrc  # TEXINPUTS=../../ so guide.cls is found
│           │   └── main.tex    # sample document in Portuguese
│           └── en/
│               ├── .latexmkrc
│               └── main.tex    # sample document in English
└── examples/                 # reference projects using the template
    └── setup-guide/          # ECS + SSH + MaaS gateway setup guide
```

## Adding a new template

1. Create `templates/<name>/` with the class file, samples, and `SKILL.md`
   (with frontmatter: `name` and `description`).
2. Add a row to the Templates table above.
3. `install.sh` will auto-discover and install the skill on next run.

## License

MIT — see [LICENSE](LICENSE).
