#!/usr/bin/env python3
"""Generate an English sample Huawei Cloud DOCX analysis report."""

import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                 '..', '..', '..', 'templates', 'docx'))
from huawei_docx import *

OUT_DIR = os.path.dirname(os.path.abspath(__file__))

def main():
    doc = new_report()

    add_heading(doc, "Problem Description and Impact", level=1)
    add_paragraph(doc,
        "At the Brazil site of HCS 8.5.1, the default enterprise project "
        "is not displayed on the ECS creation page. This prevents users "
        "from selecting the correct enterprise project when provisioning "
        "new ECS instances.")

    add_heading(doc, "Affected Versions", level=1)
    add_table(doc,
        ["Version", "Installation Scenario", "Affected"],
        [
            ["HCS 8.5.1", "Standard Scenario", "Yes"],
            ["HCS 8.5.0", "Standard Scenario", "No"],
            ["HCS 8.6.0", "Standard Scenario", "Fixed"],
        ])

    add_heading(doc, "Workaround", level=1)
    add_paragraph(doc,
        "Grant ECS FullAccess permission to the user group associated "
        "with the affected user. This restores the enterprise project "
        "list on the ECS creation page.")

    add_callout(doc, 'warning',
        "Applying this workaround modifies user group permissions. "
        "Review the impact before proceeding.")

    add_callout(doc, 'tip',
        "Back up the current permission configuration before making "
        "any changes. This allows a quick rollback if needed.")

    path = save_report(doc, os.path.join(OUT_DIR, "sample-report.docx"))
    print(f"Saved: {path}")

if __name__ == "__main__":
    main()
