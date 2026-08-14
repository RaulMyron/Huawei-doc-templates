#!/usr/bin/env python3
"""Gerar um relatório de análise DOCX de exemplo em português."""

import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                 '..', '..', '..', 'templates', 'docx'))
from huawei_docx import *

OUT_DIR = os.path.dirname(os.path.abspath(__file__))

def main():
    doc = new_report()

    add_heading(doc, "Descrição do Problema e Impacto", level=1)
    add_paragraph(doc,
        "No site do Brasil do HCS 8.5.1, o projeto empresarial padrão "
        "não é exibido na página de criação do ECS. Isso impede que os "
        "usuários selecionem o projeto empresarial correto ao provisionar "
        "novas instâncias ECS.")

    add_heading(doc, "Versões Afetadas", level=1)
    add_table(doc,
        ["Versão", "Cenário de Instalação", "Afetado"],
        [
            ["HCS 8.5.1", "Cenário Padrão", "Sim"],
            ["HCS 8.5.0", "Cenário Padrão", "Não"],
            ["HCS 8.6.0", "Cenário Padrão", "Corrigido"],
        ])

    add_heading(doc, "Solução Alternativa", level=1)
    add_paragraph(doc,
        "Conceda a permissão ECS FullAccess ao grupo de usuários associado "
        "ao usuário afetado. Isso restaura a lista de projetos empresariais "
        "na página de criação do ECS.")

    add_callout(doc, 'warning',
        "A aplicação desta solução alternativa modifica as permissões do "
        "grupo de usuários. Revise o impacto antes de prosseguir.")

    add_callout(doc, 'tip',
        "Faça backup da configuração de permissões atual antes de fazer "
        "qualquer alteração. Isso permite um rollback rápido se necessário.")

    path = save_report(doc, os.path.join(OUT_DIR, "sample-report.docx"))
    print(f"Saved: {path}")

if __name__ == "__main__":
    main()
