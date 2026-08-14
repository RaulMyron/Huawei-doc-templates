#!/usr/bin/env python3
"""Portuguese sample deck for the Huawei Cloud PPT template."""

import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                 '..', '..', '..', 'templates', 'ppt'))
from huawei_ppt import *

OUT_DIR = os.path.dirname(os.path.abspath(__file__))

def main():
    prs, layouts = new_deck()

    # Slide de título
    title_slide(prs, layouts,
                "Visão Geral do Huawei Cloud",
                "Introdução aos Serviços HCS",
                "Exemplo | Português")

    # Slide de conteúdo com tabela
    s = content_slide(prs, layouts, "Famílias de Serviços Cloud")
    ts = add_table(s, ["Família", "Serviços Principais", "Qtd"], [
        ["Computação", "ECS, IMS, AS", "3"],
        ["Armazenamento", "EVS, OBS, HBR", "3"],
        ["Rede", "VPC, EIP, ELB, NAT, VPN", "5"],
        ["Banco de Dados", "RDS, GaussDB, DRS", "3"],
    ], col_widths=[Inches(2.5), Inches(5.5), Inches(1.5)])
    callout(s, 'infobox',
            "O hotline precisa saber o nome oficial do serviço para roteamento do SR.",
            top=table_bottom(ts) + 0.3)

    # Slide de conteúdo com callouts
    s = content_slide(prs, layouts, "Lembretes Importantes")
    callout(s, 'warning',
            "Nunca solicite ou aceite credenciais. Oriente o cliente ao autoatendimento.",
            top=2.0)
    callout(s, 'tip',
            "Sempre valide a identidade do chamador contra a lista de contatos autorizados.",
            top=3.5)
    callout(s, 'infobox',
            "O ManageOne é a plataforma de operações, não um serviço cloud em si.",
            top=5.0)

    # Último slide
    last_slide(prs, layouts)

    path = save_deck(prs, os.path.join(OUT_DIR, "sample-pt.pptx"))
    print(f"Saved: {path}")

if __name__ == "__main__":
    main()
