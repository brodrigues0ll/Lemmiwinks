# Política de Segurança

> Este documento explica como relatar problemas de segurança de forma privada aos mantenedores deste repositório. **Por favor, não submeta detalhes relacionados a vulnerabilidades de segurança em Issues públicas**, para evitar que sejam exploradas antes de corrigidas.

## Versões Suportadas

Apenas a **versão de lançamento mais recente / versão de manutenção do branch principal atual (versão de documentação atual: v1.3.8, pacote de lançamento de execução atual: v1.3.7)** recebe correções de segurança. Versões mais antigas não são rastreadas retroativamente.

## Métodos de Relato de Vulnerabilidades (Por Prioridade)

1. **Recomendado**: Abra a aba `Security` na página do repositório GitHub, selecione `Report a vulnerability` e submeta um comunicado de segurança privado (Security Advisory).
2. **Alternativa**: Entre em contato com o proprietário do repositório via mensagem privada do GitHub (conta na seção About do repositório).

## Informações Recomendadas para Incluir no Relato

Para localizar e corrigir o mais rápido possível, por favor forneça no relato:

- Descrição clara do problema e impacto potencial (por exemplo: pode ser acionado remotamente? Envolve escalada de privilégios? Afeta dados do usuário final?);
- Passos mínimos de reprodução (versão do Windows, versão do IDM, parâmetros de linha de comando executados, logs relevantes);
- Arquivo ou versão afetada (SHA do commit ou tag de lançamento);
- Suas ideias preliminares sobre correção (opcional).

## Prazo de Tratamento e Processo

- O mantenedor dará a primeira resposta de confirmação em **7 dias**.
- Após a vulnerabilidade ser confirmada, será trabalhado colaborativamente com o relator para dar um cronograma preliminar de correção, com objetivo de lançar a versão corrigida dentro de um prazo razoável (geralmente dentro de 2 semanas).
- Sem consentimento do relator, o mantenedor **não** divulgará publicamente os detalhes da vulnerabilidade; após o lançamento da correção, reconhecimento será feito no `CHANGELOG.md` (se o relator aceitar).

## Escopo

Esta política **cobre**:
- Injeção de código, injeção de comandos, traversal de caminho e outros problemas de segurança no próprio script;
- Falhas que causam modificação inesperada do sistema, perda de dados ou vazamento de credenciais;
- Problemas de verificação de integridade dos artefatos de lançamento (zip).

Esta política **não cobre**:
- Problemas introduzidos pelo próprio ambiente do usuário (por exemplo, PowerShell comprometido, `cmd.exe` do sistema substituído);
- Alertas heurísticos de antivírus de terceiros sobre este script (são falsos positivos esperados, já explicados no FAQ).

## Por Favor, Não Divulgue Antes da Correção

Antes que o mantenedor confirme que o problema foi corrigido e lançado, por favor não divulgue detalhes da vulnerabilidade em fóruns públicos, blogs ou Issues. Obrigado pela cooperação.
