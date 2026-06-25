# Lista de Verificação de Manutenção / Lançamento (Segurança de Manutenção)

Esta lista de verificação é usada para reduzir o risco de "documentação/codificação/terminação de linha modificada incorretamente tornando o lado Windows inutilizável", e para tornar explícitos os passos de verificação principais.

## Antes de Submeter (Local)

- Confirme que você não alterou a codificação (deve manter UTF-8 sem BOM) ou terminação de linha (CRLF) dos arquivos `.cmd` / `.txt`; `.md` deve manter UTF-8 + LF.
- Execute a validação equivalente ao CI (executar no Windows):
  - `pwsh -NoProfile -File tools/validate.ps1`
  - Mantenedores no macOS / Linux podem usar `file -i <arquivo>` para verificar amostras de codificação; o julgamento final de codificação/terminação de linha ainda é o CI.
- Se você alterou `IAS.cmd`: verifique as linhas relevantes localmente, certifique-se de que a alteração segue a descrição do segmento de código no bloco de comentário "navegação de código".
- Se envolver um pacote de lançamento: reempacote e atualize `release/IDM-Activation-Script-v<versão>.zip` e `.sha256` correspondente, sincronize `docs/release-notes-*.md`.
- `docs/` é preservado como material público de manutenção no repositório; ao atualizar README / CHANGELOG / GitHub Release / `llms.txt`, deve verificar se existe conflito em `docs/` com número de versão, pacote de lançamento e passos de execução.
- Este repositório deve manter expressão GPL-3.0 de código aberto; não escreva documentação, Release ou modelos de Issue como repositório privado, distribuição de código fechado ou projeto não redistribuível.
- Ao modificar CI, deve preservar o passo `Guard public repository visibility`, a menos que haja uma nova guarda de visibilidade pública equivalente em substituição.

## Antes de Merge de PR (GitHub)

- `Windows validation` passou (recomenda-se configurar como item obrigatório de proteção de branch):
  1. `Guard public repository visibility` confirma que o repositório não é privado.
  2. `tools/validate.ps1` codificação / terminação de linha / detecção `cmd.exe` todos passaram.
  3. Smoke `IAS.cmd /silent` retorna `2` (caminho "modo silencioso sem parâmetro de ação", confirmando que o script de inicialização à análise de parâmetros não tem regressões).
- Se a mudança afeta o ambiente de execução (análise de parâmetros, detecção de ambiente, branch de registro, etc.): adicione uma nova linha de registro de smoke do Windows na tabela em `docs/reports/smoke-win-baseline.md`.

## Antes de Lançar (Ambiente Windows Real)

- Clique duas vezes em `IniciarAtivacao.cmd` como administrador, confirme que o autodiagnóstico antes de entrar no menu fica todo verde; coloque o script em um diretório contendo `(x86)` e tente novamente, confirme que não reporta mais "Não é possível ter \Internet".
- Execute um caminho representativo do script principal (recomendado `IAS.cmd /frz /silent /log="C:\Temp\ias.log"`), confirme que o código de saída e a saída de log são como esperado.
- Registre alertas do Defender / SmartScreen (se houver), e escreva as conclusões de volta em `docs/release-notes-*.md`.
- Recalcule e verifique `release/*.zip.sha256`:
  - PowerShell: `Get-FileHash release\IDM-Activation-Script-v<versão>.zip -Algorithm SHA256`
  - macOS / Linux: `shasum -a 256 release/IDM-Activation-Script-v<versão>.zip`
- Após o lançamento, confirme que `git status --short` mostra apenas mudanças esperadas; se preparando para fazer push, confirme primeiro que versões de README, CHANGELOG, `llms.txt`, `docs/` e ativos de Release são consistentes.
