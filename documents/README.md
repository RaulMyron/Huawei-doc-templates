# Documents

This folder is the default location for new Huawei Cloud documents created
with the templates in this project.

## Creating a new document

**Easiest way — use the chooser:**

```bash
./new-doc.sh                 # interactive — picks guide / technical / ppt
./new-doc.sh --type guide --title "ECS Setup" --lang en --name ecs-setup
```

This scaffolds a self-contained folder here with the right skeleton files.

**Or use a skill directly:**

1. Run the skill for the template you want to use:
   ```
   /skill huawei-template-guide
   ```
2. The skill will create a subfolder here, e.g. `documents/my-guide/`,
   with all necessary files (`.tex`, `.latexmkrc`, `assets/`).
3. Compile from inside the project folder:
   ```
   cd documents/my-guide
   latexmk main.tex
   ```

## Structure

Each document is self-contained in its own subfolder:

```
documents/
+-- my-guide/
    +-- main.tex           # the document
    +-- .latexmkrc         # XeLaTeX + TEXINPUTS → templates/guide/
    +-- assets/            # project-specific images
```

You can track your documents in git or ignore them — your choice.

## Multi-artifact project layout

When a single project produces multiple deliverables (a LaTeX guide, PPT
slides, and a DOCX report), use the following recommended layout:

```
documents/<project>/
├── main.tex                  # the LaTeX guide
├── .latexmkrc                # TEXINPUTS → ../../templates/guide/
├── assets/                   # guide images
├── slides/
│   ├── generate.py           # imports templates/ppt/huawei_ppt
│   └── out/                  # generated .pptx + .pdf (gitignored)
├── report/
│   ├── generate.py           # imports templates/technical/huawei_technical
│   └── out/                  # generated .docx (gitignored)
└── sources/                  # raw reference material (gitignored)
```

Key points:

- This is a **recommended layout**, not enforced by the tool. You can adapt
  it to your needs.
- Each artifact type lives in its own subfolder (`slides/`, `report/`),
  keeping generators and outputs isolated.
- `sources/` holds raw reference materials (PDFs, DOCXs from the customer)
  that feed into the deliverables. It should always be gitignored to avoid
  committing large or sensitive files.
- `out/` folders contain generated files (`.pptx`, `.pdf`, `.docx`) and
  should always be gitignored — they are build artifacts.
- The tool discovers engines by file presence: `.tex` → LaTeX, `generate.py`
  in `slides/` → PPT, `generate.py` in `report/` → DOCX.
- The LaTeX guide at the project root follows the same conventions as a
  single-artifact project (`.latexmkrc`, `assets/`).
