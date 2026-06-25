# Estrutura do Repositório e Notas de Manutenção (Perspectiva de Arquitetura)

Este repositório é um projeto focado principalmente em scripts Windows, com objetivo de manutenção: execução estável no ambiente de console Windows e evitar "funciona na aparência, quebra no Windows" por diferenças de codificação/terminação de linha/ambiente.

## Estrutura de Diretórios

- `.github/workflows/ci.yml`
  - Ponto de entrada do workflow do GitHub Actions (Windows runner).
  - Dois passos: 1) Chama `tools/validate.ps1` para verificação de higiene do repositório (codificação, terminação de linha, detecção básica de disponibilidade de `cmd.exe`); 2) Usa `IAS.cmd /silent` para smoke do caminho mais curto, afirmando código de saída `2` (caminho "modo silencioso sem parâmetro de ação").
- `.github/ISSUE_TEMPLATE/`
  - `bug_report.yml`: modelo estruturado de relato de Bug, obrigando versão do Windows / IDM / script e saída do autodiagnóstico do `IniciarAtivacao.cmd`.
  - `help.yml`: modelo de ajuda de uso / perguntas de iniciantes.
  - `config.yml`: desabilita Issues em branco, orienta a verificar FAQ e CHANGELOG primeiro.
- `tools/validate.ps1`
  - Script de validação CI: força `.cmd` a ser UTF-8 sem BOM (saída de console necessária); `.txt` não força codificação (Bloco de Notas, `Instrucoes.txt` usa UTF-8 BOM); verifica terminações de linha por `.gitattributes` (CRLF/LF); executa detecção leve de `cmd.exe` no final.
  - Objetivo é bloquear o mais cedo possível no CI commits de "codificação/terminação de linha automaticamente corrompida pelo editor" de entrar no branch principal.
- `IAS.cmd`
  - Script batch principal (aproximadamente 1000 linhas), contendo análise de parâmetros, detecção de ambiente, fluxos de ativação/congelamento/redefinição, backup de registro e saída de log.
  - Cabeçalho contém bloco de comentário "navegação de código", marcando posições dos segmentos de código principais por intervalo de linha.
  - Nota de manutenção: este arquivo depende de terminações de linha CRLF e codificação UTF-8; conversão automática por alguns ambientes/editores causará anomalias. O script faz autodetecção de LF/CRLF na inicialização.
- `IniciarAtivacao.cmd` (único ponto de entrada desde v1.3.6, fundindo os quatro scripts anteriores)
  - Eleva automaticamente usando PowerShell (aspas simples para envolver o caminho, compatível com diretórios contendo `(x86)` e outros caracteres especiais).
  - Autodiagnóstico integrado: permissões de administrador, modo de linguagem do PowerShell, serviço Null, conectividade de rede, página de código, WMI/CIM, caminho de instalação do IDM, permissão de escrita do diretório.
  - Após passar no autodiagnóstico ou confirmação do usuário, `call IAS.cmd` entra no menu (Congelar / Ativar / Redefinir / Baixar / Ajuda); também aceita passagem de parâmetros `/frz` `/act` `/res` `/silent /log=...`.
- `Instrucoes.txt`
  - Guia de início rápido ultra-simples (UTF-8 BOM + CRLF), voltado para usuários iniciantes.
- `README.md` / `CHANGELOG.md` / `CONTRIBUTING.md` / `SECURITY.md` / `ARCHITECTURE.md`
  - README: documentação completa do lado do usuário (funcionalidades, uso, FAQ, detalhes técnicos).
  - CHANGELOG: histórico de versões único para uso externo.
  - CONTRIBUTING: restrições de codificação/terminação de linha e passos de autovalidação antes de submeter.
  - SECURITY: canais de relato de vulnerabilidades de segurança e processo de tratamento.
  - ARCHITECTURE: este arquivo, estrutura do repositório e pontos de alto risco do ponto de vista do mantenedor.
- `docs/`
  - `README.md`: índice de documentação pública, explicando entradas de documentação e limites de veracidade para novos usuários, mantenedores e mecanismos de busca por IA.
  - `release-notes-v1.3.7.md` / `release-notes-v1.3.6.md` / `release-notes-v1.3.5.md`: notas de lançamento de execução/documentação recentes.
  - `release-notes-v1.3.4.md`: notas de lançamento especial de documentação v1.3.4.
  - `release-notes-v1.3.3.md`: notas de lançamento de execução v1.3.3 e sugestões de regressão.
  - `release-notes-v1.3.1.md`: notas de lançamento históricas v1.3.1 (preservadas).
  - `release-notes-v1.3.md`: notas de lançamento históricas v1.3 (preservadas).
  - `maintenance-checklist.md`: lista de verificação de manutenção/lançamento.
  - `reports/smoke-win-baseline.md`: template de baseline de smoke Windows da versão atual.
  - Restrição de manutenção: `docs/` é preservado como material público de manutenção no repositório; ao lançar, deve-se sincronizar informações visíveis ao usuário no README / CHANGELOG / llms.txt, evitando contradições entre documentos públicos.
- `release/`
  - Artefatos de lançamento: `IDM-Activation-Script-v<versão>.zip` e arquivo de checksum `.sha256` correspondente.

## Restrições Críticas (Pontos de Alto Risco)

- Codificação: `.cmd` deve usar UTF-8 sem BOM (página de código 65001), caso contrário o CI falhará.
- Terminação de linha: `.cmd`/`.txt` deve manter CRLF; `.md` usa LF (restrito por `.gitattributes` e validação CI).
- Diferenças de ambiente de execução: os scripts dependem muito de componentes do sistema Windows (por exemplo, `cmd.exe`, PowerShell, WMI, etc.); macOS/Linux não podem fazer verificação de execução equivalente, portanto é necessário complementar a confiança do lançamento com registros de smoke do Windows.

## Fluxo de Dados CI (Perspectiva do Mantenedor)

1. push / PR / `workflow_dispatch` manual aciona o GitHub Actions (`windows-latest`).
2. Após o checkout do código, executa em sequência:
   - `tools/validate.ps1`: valida codificação (UTF-8/sem BOM), terminação de linha (por `.gitattributes`), disponibilidade básica de `cmd.exe`. Em falha, anota com `::error file=...::razão` na linha correspondente, visível diretamente no diff do PR.
   - Smoke `IAS.cmd /silent`: chama o corpo principal do script após `chcp 65001`, afirma código de saída `2` (sem parâmetro de ação → saída silenciosa). Este é o caminho de inicialização mais curto do script, capaz de detectar regressões de sintaxe ou análise de parâmetros sem depender de admin/rede/IDM.
3. Qualquer falha bloqueia o merge (recomenda-se configurar `Windows validation` como item obrigatório de proteção de branch nas configurações do repositório GitHub).

## Semântica de Códigos de Saída (Referência Rápida)

- Códigos de saída do `IAS.cmd`:
  - `0`: caminho atual concluído normalmente (saída do menu, ativação/congelamento/redefinição concluída com sucesso).
  - `2`: erro de ambiente/parâmetros (modo silencioso sem parâmetro de ação, versão do sistema não suportada, sem PowerShell, sem permissões de administrador, falha WMI, falha de gravação CLSID, execução bloqueada a partir de diretório temporário, etc.).
- Códigos de saída do `IniciarAtivacao.cmd`: quando o autodiagnóstico encontra problemas, cabe ao usuário decidir se continua; sair retorna `1`, caso contrário entra no menu e passa o código de retorno do `IAS.cmd` inalterado.
