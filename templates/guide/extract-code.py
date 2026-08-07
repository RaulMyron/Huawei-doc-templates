#!/usr/bin/env python3
"""
extract-code.py — Extract code blocks from a LaTeX source file and generate
an HTML companion page with copy-to-clipboard buttons.

Solves the PDF copy-paste problem: text extraction from listings-based code
blocks in XeLaTeX PDFs is unreliable (extra spaces, smart quotes, etc.).
This script generates a clean HTML page where each command has a Copy button.

Usage:
    python3 extract-code.py document.tex              # → document-commands.html
    python3 extract-code.py document.tex output.html  # custom output path
"""

import re
import sys
import os
from html import escape


def extract_title(tex_content):
    """Extract the document title from \\setguidetitle{...}."""
    m = re.search(r'\\setguidetitle\{([^}]*)\}', tex_content)
    return m.group(1) if m else "Commands"


def extract_code_blocks(tex_content):
    """Extract code blocks with section/subsection context."""
    blocks = []
    current_section = ""
    current_subsection = ""
    current_item = ""

    lines = tex_content.split('\n')
    i = 0
    while i < len(lines):
        line = lines[i]

        # Track sections
        m = re.match(r'\\section\{([^}]*)\}', line.strip())
        if m:
            current_section = m.group(1)
            current_subsection = ""

        m = re.match(r'\\subsection\{([^}]*)\}', line.strip())
        if m:
            current_subsection = m.group(1)

        # Track enumerate items for context
        m = re.match(r'\\item\s+(.*)', line.strip())
        if m:
            current_item = m.group(1).strip()
            # Clean up LaTeX commands in item text
            current_item = re.sub(r'\\textbf\{([^}]*)\}', r'\1', current_item)
            current_item = re.sub(r'\\code\{([^}]*)\}', r'\1', current_item)
            current_item = re.sub(r'\\weblink\{[^}]*\}\{([^}]*)\}', r'\1', current_item)
            current_item = current_item[:80]  # truncate

        # Find codigo environment
        if '\\begin{codigo}' in line:
            lang_match = re.search(r'\\begin{codigo}\[([^\]]*)\]', line)
            lang = lang_match.group(1) if lang_match else ""

            # Collect code until \end{codigo}
            code_lines = []
            i += 1
            while i < len(lines) and '\\end{codigo}' not in lines[i]:
                code_lines.append(lines[i])
                i += 1

            code = '\n'.join(code_lines).rstrip()
            if code.strip():  # skip empty blocks
                blocks.append({
                    'section': current_section,
                    'subsection': current_subsection,
                    'context': current_item,
                    'language': lang,
                    'code': code,
                })
        i += 1

    return blocks


def generate_html(blocks, title, source_file):
    """Generate self-contained HTML page with copy buttons."""
    
    # Group blocks by section
    sections = {}
    for b in blocks:
        key = b['section']
        if key not in sections:
            sections[key] = []
        sections[key].append(b)

    # Build code blocks HTML
    blocks_html = []
    section_num = 0
    for section_name, section_blocks in sections.items():
        section_num += 1
        blocks_html.append(f'    <h2>{section_num}. {escape(section_name)}</h2>')
        
        current_sub = None
        for b in section_blocks:
            if b['subsection'] != current_sub:
                current_sub = b['subsection']
                if current_sub:
                    blocks_html.append(f'    <h3>{escape(current_sub)}</h3>')
            
            code_escaped = escape(b['code'])
            code_js = b['code'].replace('\\', '\\\\').replace("'", "\\'").replace('\n', '\\n')
            lang_label = b['language'] or 'text'
            context = f'<div class="context">{escape(b["context"])}</div>' if b['context'] else ''
            
            blocks_html.append(f'''    <div class="code-block">
      <div class="code-header">
        <span class="code-lang">{escape(lang_label)}</span>
        <button class="copy-btn" onclick="copyToClipboard(this, '{code_js}')">Copy</button>
      </div>
      {context}
      <pre><code>{code_escaped}</code></pre>
    </div>''')

    blocks_html_str = '\n'.join(blocks_html)

    return f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{escape(title)} — Commands</title>
  <style>
    :root {{
      --huawei-red: #C7000B;
      --code-bg: #F6F8FA;
      --code-text: #1F2328;
      --border: #d0d7de;
      --header-bg: #eaeef2;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'HarmonyOS Sans', sans-serif;
      max-width: 920px;
      margin: 0 auto;
      padding: 24px 20px;
      color: #1F2328;
      line-height: 1.5;
    }}
    h1 {{
      color: var(--huawei-red);
      border-bottom: 2px solid var(--huawei-red);
      padding-bottom: 10px;
      font-size: 1.5em;
    }}
    h2 {{
      margin-top: 36px;
      font-size: 1.2em;
      border-bottom: 1px solid var(--border);
      padding-bottom: 6px;
    }}
    h3 {{
      color: #656d76;
      font-weight: 600;
      font-size: 1em;
      margin-top: 24px;
    }}
    .info {{
      background: #E3F2FD;
      border-left: 3px solid #1565C0;
      padding: 10px 16px;
      margin: 16px 0;
      border-radius: 0 6px 6px 0;
      font-size: 0.9em;
    }}
    .code-block {{
      background: var(--code-bg);
      border: 1px solid var(--border);
      border-radius: 6px;
      margin: 8px 0 16px;
      overflow: hidden;
    }}
    .code-header {{
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 6px 12px;
      background: var(--header-bg);
      border-bottom: 1px solid var(--border);
    }}
    .code-lang {{
      font-size: 11px;
      color: #656d76;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }}
    .copy-btn {{
      background: var(--huawei-red);
      color: white;
      border: none;
      padding: 4px 14px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 12px;
      font-weight: 600;
      transition: opacity 0.2s;
    }}
    .copy-btn:hover {{ opacity: 0.85; }}
    .copy-btn.copied {{ background: #2E7D32; }}
    .context {{
      padding: 6px 12px;
      font-size: 0.85em;
      color: #656d76;
      border-bottom: 1px solid var(--border);
      background: #fff;
    }}
    pre {{
      margin: 0;
      padding: 12px;
      overflow-x: auto;
    }}
    code {{
      font-family: 'Cascadia Code', 'Consolas', 'Courier New', monospace;
      font-size: 13px;
      color: var(--code-text);
      white-space: pre;
    }}
    .footer {{
      margin-top: 40px;
      padding-top: 12px;
      border-top: 1px solid var(--border);
      font-size: 0.8em;
      color: #656d76;
    }}
  </style>
</head>
<body>
  <h1>{escape(title)}</h1>
  <div class="info">
    Commands extracted from <code>{escape(source_file)}</code>.
    Click <strong>Copy</strong> to copy any command to your clipboard.
  </div>
{blocks_html_str}
  <div class="footer">
    Generated by <code>extract-code.py</code> from the Huawei guide template.
  </div>
  <script>
    function copyToClipboard(btn, code) {{
      navigator.clipboard.writeText(code).then(function() {{
        btn.textContent = 'Copied!';
        btn.classList.add('copied');
        setTimeout(function() {{
          btn.textContent = 'Copy';
          btn.classList.remove('copied');
        }}, 2000);
      }});
    }}
  </script>
</body>
</html>'''


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 extract-code.py document.tex [output.html]")
        sys.exit(1)

    tex_file = sys.argv[1]
    if len(sys.argv) >= 3:
        output_file = sys.argv[2]
    else:
        base = os.path.splitext(tex_file)[0]
        output_file = f"{base}-commands.html"

    with open(tex_file, 'r', encoding='utf-8') as f:
        tex_content = f.read()

    title = extract_title(tex_content)
    blocks = extract_code_blocks(tex_content)

    if not blocks:
        print(f"No code blocks found in {tex_file}")
        sys.exit(0)

    html = generate_html(blocks, title, os.path.basename(tex_file))

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html)

    print(f"Extracted {len(blocks)} code blocks → {output_file}")


if __name__ == '__main__':
    main()
