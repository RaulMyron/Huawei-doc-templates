# Huawei Cloud Document Templates

This directory contains the self-contained, Huawei-branded document templates.
Each template lives in its own subfolder and is discovered as an opencode skill
via `templates/*/SKILL.md`.

## Available templates

| Template | Engine | Output | Skill | Best for |
|---|---|---|---|---|
| [`guide`](guide/) | LaTeX (XeLaTeX) | `.pdf` | `huawei-template-guide` | Training materials, how-to guides, step-by-step instructions. Custom section structure, code blocks, images, callouts, changelog. |
| [`technical`](technical/) | DOCX (python-docx) | `.docx` (+ `.pdf`) | `huawei-template-technical` | Formal incident/issue reports with the standard 6-section structure (problem → root cause → trigger → workaround). Customer-facing technical reports. |
| [`ppt`](ppt/) | PPTX (python-pptx) | `.pptx` (+ `.pdf`) | `huawei-template-ppt` | Slide decks and presentations. Title/chapter/content slides, tables, callouts. |

## Choosing a template

**Not sure which one to use?** Run the interactive chooser from the repo root:

```bash
./new-doc.sh
```

It asks which template, a title, a language (English/Portuguese), and a project
name, then scaffolds a self-contained project folder under `documents/<name>/`.

You can also skip the prompts:

```bash
./new-doc.sh --type guide     --title "ECS Setup"     --lang en --name ecs-setup
./new-doc.sh --type technical --title "ECS Incident"  --lang pt --name ecs-incident
./new-doc.sh --type ppt       --title "HCS Overview"  --lang en --name hcs-overview
```

### Quick decision guide

- **Writing a guide / tutorial / how-to?** → `guide` (LaTeX → PDF). Legible,
  custom structure, code blocks, images.
- **Writing an incident / root-cause / workaround report?** → `technical`
  (DOCX). Fixed 6-section structure, placeholder-driven, customer-facing.
- **Building a slide deck / presentation?** → `ppt` (PPTX). Branded slides,
  tables, callouts.

### Multi-artifact projects

A single project can produce several deliverables (guide + slides + report).
See [`documents/README.md`](../documents/README.md) for the recommended
multi-artifact layout.

## Conventions

Every template follows the same self-contained convention (see
[`AGENTS.md`](../AGENTS.md) for the locked decisions):

```
templates/<name>/
├── SKILL.md           # opencode skill (YAML frontmatter: name, description)
├── README.md          # brief human docs
├── common-assets/     # logos, sample images, brand template file
└── <engine files>     # .cls+.latexmkrc (LaTeX) | .py+.docx (DOCX) | .py+.pptx (PPT)
```

- **Skill prefix** is locked to `huawei-template-` (AGENTS.md L7).
- **Brand colors** are hardcoded to the Huawei house style (AGENTS.md L9).
- **Callout names** are `warning`, `tip`, `infobox` (AGENTS.md L3).
- Samples live in `examples/<name>/pt/` and `examples/<name>/en/`.

See the [root README](../README.md) for setup, compilation, and project layout.
