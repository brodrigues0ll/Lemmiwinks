# Guia de Contribuição (Segurança de Manutenção)

Este repositório contém batch do Windows e arquivos de texto. Para evitar "parece bom, mas quebra no Windows" por modificações incorretas, siga as restrições abaixo antes de submeter.

## Princípios Básicos

- Não submeta quaisquer chaves, tokens, informações de privacidade pessoal ou características de máquina no repositório.
- Este repositório é mantido como código aberto sob GPL-3.0; documentação, notas de lançamento e notas de derivações devem manter expressão publicamente verificável, reutilizável e redistribuível — não descreva o projeto como privado ou distribuição de código fechado.
- Qualquer mudança deve passar no workflow `Windows validation` do GitHub Actions.
- Tente manter mudanças pequenas e reversíveis: um PR faz uma coisa (documentação/CI/lógica do script por favor separe).

## Codificação e Terminação de Linha (Mais Importante)

Este repositório tem restrições fortes na codificação/terminação de linha dos arquivos:

- `*.cmd`: UTF-8 sem BOM + CRLF
- `*.txt`: UTF-8 com BOM + CRLF
- `*.md`: UTF-8 (sem BOM) + LF

Restrições relacionadas são verificadas por `.gitattributes` e `tools/validate.ps1`; CI bloqueará merge se não passar.

### Erros Comuns

- Não salve `.cmd` como UTF-8 com BOM; o console pode exibir caracteres incorretos e acionará falha no CI.
- Não mude `.cmd` para terminações de linha LF; o batch pode se comportar de forma anômala em alguns ambientes, e `IAS.cmd` também tem detecção de LF internamente.

## Autovalidação Local (Recomendado)

Execute no Windows PowerShell / PowerShell 7:

`pwsh -NoProfile -File tools/validate.ps1`

Se o script reportar erros, saída específica do arquivo e razão via `::error`; corrija antes de submeter.

## Explicação do CI

- Arquivo de workflow: `.github/workflows/ci.yml`
- Script de validação: `tools/validate.ps1`
- Ambiente de execução: Windows runner hospedado pelo GitHub (`windows-latest`)
