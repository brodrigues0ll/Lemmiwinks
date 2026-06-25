# IDM Script de Ativação PT-BR v1.3.3 Baseline de Smoke Windows

## Escopo e Pré-requisitos
- Validação mínima de um caminho (congelar `/frz`, ativar `/act` ou redefinir `/res`), congelar é recomendado.
- Ambiente: Win10/11 x64 (incluindo 24H2, CMD como administrador), IDM instalado, página de código 65001, rede com acesso direto a `internetdownloadmanager.com`.
- Pacote: `release/IDM-Activation-Script-v1.3.3.zip`.
- SHA256: `e85d8f0c4c1f499c0996460bba41ec97cbe98f89914ca2744696b9aecbe19e98` (o arquivo `.sha256` no mesmo diretório deve coincidir).

## Smoke Automatizado (GitHub Actions, habilitado)
- Workflow: [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml), acionado por `push` / `pull_request` / `workflow_dispatch`.
- Passos de validação:
  1. `pwsh tools/validate.ps1`: codificação (UTF-8, sem BOM), terminação de linha (por `.gitattributes`), detecção básica de `cmd.exe`.
  2. `chcp 65001 && IAS.cmd /silent`: afirma código de saída `2` (caminho "modo silencioso sem parâmetro de ação"), cobrindo inicialização do script até análise de parâmetros.
- Estes dois passos só podem verificar sintaxe e caminho mais curto; funcionalidade completa (gravação no registro, download de rede, elevação de UI) deve ser executada manualmente no ambiente real do Windows abaixo.

## Passos de Execução de Smoke Manual (Obrigatório Antes do Lançamento)
1. `IniciarAtivacao.cmd` (como administrador), confirme 10/10 verde e código de saída `0`; se falhar, registre o "primeiro item com falha" impresso no final do script e a seção README correspondente.
2. Execute um caminho de entrada representativo (`IAS.cmd /frz|/act|/res`), recomendado silencioso + log, por exemplo `IAS.cmd /frz /silent /log="C:\Temp\ias.log"`, código de saída esperado `0`, log gravado com sucesso.
3. Observe se há interceptação do Defender / SmartScreen, anomalia de janela UAC ou caracteres incorretos, e anote na tabela de registro.
4. Antes de submeter PR, execute `IAS.cmd /silent` (sem parâmetro de ação) uma vez separadamente, confirme que o código de saída é `2` (mesmo smoke do CI, pode detectar regressões localmente mais cedo).

## Template de Registro
| Data | SO / Versão | Comando Executado | Código de Saída | Caminho do Log | Observações |
| --- | --- | --- | --- | --- | --- |
| A preencher |  |  |  |  |  |

## Status Atual
- v1.3.3 completou verificação SHA256 do pacote de lançamento; GitHub Actions `Windows validation` passou tanto no `main` quanto na tag `v1.3.3`, cobrindo smoke do caminho mais curto `/silent`.
- A regressão pré-lançamento do fluxo real de registro do IDM (congelar / ativar / redefinir) deve ser completada no ambiente de administrador Win10/11 e adicionada à tabela acima com descrição de anomalias / capturas de tela (se houver).
- 2026-05-26: O autodiagnóstico de caminho do IDM em `IniciarAtivacao.cmd` foi complementado com `HKCU DownloadManager\ExePath` e fallback para diretório de instalação padrão, evitando dependência apenas de `InstallFolder` do HKLM; ainda necessita execução de teste de detecção de caminho no ambiente real Win11 + IDM 6.42+.
