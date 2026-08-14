---
name: huawei-template-docx
description: Create or edit Huawei Cloud DOCX reports using the analysis report template. Use when the user wants to create a report, analysis report, or DOCX document for Huawei Cloud. Triggers on keywords like huawei-template-docx, huawei report, analysis report, relatório, docx.
---

# Huawei Cloud DOCX — Skill

Create and generate Huawei Cloud DOCX reports (`.docx`) using the
`huawei_docx` Python library and the bundled Huawei analysis report template.

## When to use

Use this skill when the task is to **create a Huawei Cloud analysis report
or DOCX document**. The output is a `.docx` file (and optionally a `.pdf`
via LibreOffice). Do **not** use this for general DOCX files — the formatting
is hard-coded to the Huawei house style (AGENTS.md L9).

---

## Quick start — creating a new report

1. **Ask for the essentials** (if not already provided):
   - **Title** — e.g. "ECS Creation Page Analysis Report"
   - **Language** — English (default) or Portuguese
   - **Project name** — used as the folder name (e.g. `ecs-analysis`)

2. **Create a self-contained project folder** at `documents/<project-name>/`:
   - Inside the folder, create:
     - `generate.py` — the report generator (see skeleton below).
     - `assets/` subfolder for project-specific images.

3. **Run the generator** with `python3 generate.py` from inside the
   project folder.

4. **Report** the output file path to the user.

---

## Hard requirements

- **Python 3.8+** with `python-docx >= 1.1` and `lxml >= 4.9`.
  Install with: `pip install -r templates/docx/requirements.txt`
- **LibreOffice** (optional) — needed only for PDF export via `to_pdf()`.
- **The bundled template** — `templates/docx/common-assets/analysis-report-template.docx`
  must be present. It provides the styles, sections, and page layout.

---

## Project layout (this directory)

```
templates/docx/
├── huawei_docx.py              # the library — all formatting helpers live here
├── SKILL.md                    # this file (opencode skill)
├── README.md                   # human docs (brief)
├── requirements.txt            # Python dependencies
└── common-assets/
    └── analysis-report-template.docx  # brand DOCX template (styles + layout)

# Each document has its own folder:
documents/
└── my-report/
    ├── generate.py             # report generator script
    └── assets/                 # project-specific images

# Samples:
examples/docx/
├── en/
│   └── generate.py             # English sample
└── pt/
    └── generate.py             # Portuguese sample
```

**Rule of thumb:** content/structure goes in `generate.py`; look-and-feel
goes in `huawei_docx.py` and the template. Do not inline formatting
overrides in the generator unless the user asks.

---

## Template structure

The bundled `analysis-report-template.docx` is a Huawei Cloud analysis
report template with these sections:

| Section | Content |
|---|---|
| Cover page | Title, version, date (in a styled table) |
| Copyright | Copyright notice |
| Company info | Huawei Technologies Co., Ltd. address and website |
| Safety | Safety statement and vulnerability handling process |
| Version info | Detailed version, installation scenario, management scale |
| Contents | Auto-generated table of contents |
| Problem Description and Impact | Heading 1 section |
| Root Cause Analysis | Heading 1 section |
| Root Cause | Heading 1 section |
| Trigger Condition | Heading 1 section |
| Workaround and Impact | Heading 1 section with subsections for impact, backup, workaround, verification, rollback, cleanup |

Use `fill_section(doc, placeholder, text)` to replace placeholders in the
template, or `add_heading` / `add_paragraph` to append new content.

---

## API reference

### Report creation

| Function | Signature | Returns |
|---|---|---|
| `load_template` | `load_template(template_path=None)` | Document object from template |
| `new_report` | `new_report(template_path=None)` | Document object (alias for `load_template`) |
| `save_report` | `save_report(doc, filepath)` | Absolute path to saved `.docx` |
| `to_pdf` | `to_pdf(docx_path)` | Path to generated `.pdf` |

### Content builders

| Function | Signature | Returns |
|---|---|---|
| `add_heading` | `add_heading(doc, text, level=1)` | Heading paragraph (level 1 gets Huawei red) |
| `add_paragraph` | `add_paragraph(doc, text, style=None)` | Paragraph object |
| `add_table` | `add_table(doc, headers, rows)` | Table with Huawei red header, alternating rows, first column bold |
| `add_callout` | `add_callout(doc, kind, text)` | Single-cell table with colored background |
| `fill_section` | `fill_section(doc, placeholder, text)` | Number of replacements made |

### Callout kinds (locked — AGENTS.md L3)

| Kind | Background | Border | Label | Use |
|---|---|---|---|---|
| `'warning'` | Amber `#FFF8E1` | Amber `#FFC107` | **Important** | Warning / caution — potential pitfalls |
| `'tip'` | Green `#E8F5E9` | Green `#28A745` | **Tip** | Tip / suggestion — best practices |
| `'infobox'` | Blue `#E3F2FD` | Blue `#17A2B8` | **Info** | Informational note — helpful context |

---

## Brand colors (locked — AGENTS.md L9)

| Name | Hex | Use |
|---|---|---|
| `HUAWEI_RED` | `#C7000B` | Huawei brand red (headers, accents) |
| `CODE_BG` | `#F6F8FA` | Code / alternating table row background |
| `CODE_TEXT` | `#1F2328` | Code text / body text |
| `LINK_BLUE` | `#0000FF` | Links |
| `RULE_BLACK` | `#000000` | Horizontal rules |
| `WHITE` | `#FFFFFF` | White |
| `DARK` | `#1F2328` | Body text |
| `GRAY_BG` | `#F6F8FA` | Alternating table row background |
| `WARNING_BG/FG/BD` | `#FFF8E1` / `#F57C00` / `#FFC107` | Warning callout |
| `TIP_BG/FG/BD` | `#E8F5E9` / `#2E7D32` / `#28A745` | Tip callout |
| `INFO_BG/FG/BD` | `#E3F2FD` / `#1565C0` / `#17A2B8` | Infobox callout |

---

## Skeleton `generate.py`

```python
#!/usr/bin/env python3
"""Generate a Huawei Cloud analysis report."""

import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                 '..', '..', 'templates', 'docx'))
from huawei_docx import *

OUT_DIR = os.path.dirname(os.path.abspath(__file__))

def main():
    doc = new_report()

    add_heading(doc, "Problem Description", level=1)
    add_paragraph(doc, "Describe the problem and its impact here.")

    add_heading(doc, "Root Cause", level=1)
    add_paragraph(doc, "Explain the root cause.")

    add_heading(doc, "Affected Versions", level=1)
    add_table(doc, ["Version", "Affected"], [
        ["HCS 8.5.1", "Yes"],
        ["HCS 8.5.0", "No"],
    ])

    add_callout(doc, 'warning', "Applying the workaround requires tenant plane access.")
    add_callout(doc, 'tip', "Back up data before applying any workaround.")

    path = save_report(doc, os.path.join(OUT_DIR, "report.docx"))
    print(f"Saved: {path}")

if __name__ == "__main__":
    main()
```

---

## Compilation

From the project folder:

```bash
python3 generate.py                    # creates .docx
python3 -c "from huawei_docx import to_pdf; to_pdf('report.docx')"  # optional PDF
```

PDF export requires LibreOffice (`soffice`) installed and available on PATH.

---

## Agent workflow checklist

1. Import `huawei_docx` at the top of `generate.py` (use `sys.path.insert`
   to point to `templates/docx/`).
2. Use `new_report()` to start from the template.
3. Add content with `add_heading`, `add_paragraph`, `add_table`, `add_callout`.
4. Use `fill_section()` to replace template placeholders.
5. Save with `save_report()`.
6. Run `python3 generate.py` and verify the output.
