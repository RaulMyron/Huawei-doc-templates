#!/usr/bin/env python3
"""English sample deck for the Huawei Cloud PPT template."""

import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                 '..', '..', '..', 'templates', 'ppt'))
from huawei_ppt import *

OUT_DIR = os.path.dirname(os.path.abspath(__file__))

def main():
    prs, layouts = new_deck()

    # Title slide
    title_slide(prs, layouts,
                "Huawei Cloud Overview",
                "Introduction to HCS Services",
                "Sample Deck | English")

    # Content slide with a table
    s = content_slide(prs, layouts, "Cloud Service Families")
    ts = add_table(s, ["Family", "Key Services", "Count"], [
        ["Compute", "ECS, IMS, AS", "3"],
        ["Storage", "EVS, OBS, HBR", "3"],
        ["Network", "VPC, EIP, ELB, NAT, VPN", "5"],
        ["Database", "RDS, GaussDB, DRS", "3"],
    ], col_widths=[Inches(2.5), Inches(5.5), Inches(1.5)])
    callout(s, 'infobox',
            "The hotline needs to know the official service name for SR routing.",
            top=table_bottom(ts) + 0.3)

    # Content slide with callouts
    s = content_slide(prs, layouts, "Key Reminders")
    callout(s, 'warning',
            "Never ask for or accept credentials. Guide the customer to self-service.",
            top=2.0)
    callout(s, 'tip',
            "Always validate the caller identity against the authorized contact list.",
            top=3.5)
    callout(s, 'infobox',
            "ManageOne is the operations platform, not a cloud service itself.",
            top=5.0)

    # Last slide
    last_slide(prs, layouts)

    path = save_deck(prs, os.path.join(OUT_DIR, "sample-en.pptx"))
    print(f"Saved: {path}")

if __name__ == "__main__":
    main()
