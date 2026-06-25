# Histórico de Versões (CHANGELOG)

Este arquivo registra todas as mudanças externas do IDM Script de Ativação PT-BR. O versionamento segue o estilo [Semantic Versioning](https://semver.org/): `Major.Minor.Patch`.

- Formato: cada versão contém rótulos `Novo / Alterado / Corrigido / Documentação / Compatibilidade` (conforme necessário).
- Datas usam o fuso horário local (America/Sao_Paulo).
- Versão mais recente no topo; versões congeladas não são revisadas retroativamente.

---

## v1.3.8 — 2026-06-23

### Documentação
- **Unificação da atribuição upstream**: a seção de licença do README originalmente citava `WindowsAddict/IDM-Activation-Script`, conflitando com o uso consistente de `lstprjct/IDM-Activation-Script` no topo do README, `llms.txt` e neste CHANGELOG. Unificado para `lstprjct/IDM-Activation-Script`, e removida a data de arquivamento não verificável, para evitar que buscas tradicionais e IA encontrem "fontes de fatos" contraditórias.
- **Corrigido guia de ativação para iniciantes**: a "rota de leitura para novos usuários" em `docs/README.md` ainda dizia "iniciantes devem selecionar `[1]` Ativar por Congelamento no menu", o oposto da recomendação real do script desde v1.3.6 (padrão é `[2]` Ativar, `[1]` Congelar apenas como alternativa). Alinhado para prioridade do `[2]` Ativar, exemplo de comando também atualizado para `IAS.cmd /act`.
- **Completar índice de documentação**: a lista de notas de lançamento em `docs/README.md` e a enumeração de arquivos `docs/` em `ARCHITECTURE.md` anteriormente listavam apenas até v1.3.4/v1.3.5; adicionadas entradas de notas de lançamento v1.3.5–v1.3.7 para que o índice seja consistente com os arquivos reais.

### Compatibilidade
- **Zero mudanças em scripts de execução e pacote de lançamento**: comportamento de `IAS.cmd` / `IniciarAtivacao.cmd` inalterado; pacote de lançamento de execução ainda é `release/IDM-Activation-Script-v1.3.7.zip` (SHA256 inalterado). Esta versão é revisão apenas de documentação; usuários já em v1.3.7 **não precisam baixar o script novamente**.

---

## v1.3.7 — 2026-06-14

### Documentação
- **Descrição de seleção de modo distinguida por estado atual do usuário**: sem período de teste de 30 dias / quer usar diretamente → `[2]` Ativar (mais comum); já ativou e está usando período de teste de 30 dias (tem conta, clicou em "iniciar teste") → `[1]` Congelar (congela o período de teste atual para não expirar); quando `[2]` Ativar ainda mostrar "não registrado", use também `[1]` Congelar como alternativa. README / `Instrucoes.txt` / `llms.txt` atualizados de forma sincronizada.

### Lançamento
- Adicionado `release/IDM-Activation-Script-v1.3.7.zip` e `.sha256` correspondente (lógica do script consistente com v1.3.6, apenas versão `iasver` e texto de seleção de modo atualizados).

---

## v1.3.6 — 2026-06-14

### Correções
- **Falso positivo "diretório do script sem permissão de escrita" no autodiagnóstico** (relacionado às issues #11 #13 #14): a instrução de teste de escrita `> "!writeTest!" echo test >nul 2>&1` tinha `>nul` sobrescrevendo o redirecionamento anterior para o arquivo de teste, fazendo com que o arquivo nunca fosse gravado, e `if exist` sempre fosse falso, reportando incorretamente qualquer diretório gravável como "não gravável". Corrigido para `(echo test)> "!writeTest!" 2>nul`.
- **Crash de elevação quando o diretório de instalação contém `(x86)` reportando "Não é possível ter \\Internet"** (relacionado à issue #12): a sintaxe de elevação do script de entrada antigo `Start-Process -FilePath \"%~f0\"` tinha `\"` fazendo o CMD fechar a citação prematuramente, fazendo `)` no caminho ser tratado como símbolo de sintaxe. O novo `IniciarAtivacao.cmd` usa aspas simples para envolver o caminho e evita blocos de parênteses.
- **Falso positivo de autodiagnóstico WMI no Win11 24H2/25H2** (relacionado à issue #14): `wmic` foi removido em novas versões do Windows; autodiagnóstico agora usa `Get-CimInstance` do PowerShell como prioridade, com `wmic` apenas como fallback.
- O autodiagnóstico de página de código agora usa `chcp | find "65001"` para evitar falhas de análise causadas por variações de formato de saída `chcp` em diferentes regiões/ambientes.
- **Corrigidos caracteres incorretos durante o processo de ativação**: funções de coloração `:_color` / `:_color2` do `IAS.cmd` no console antigo (com "Usar console legado" marcado ou `HKCU\Console\ForceV2=0`) usavam `powershell write-host 'texto'` para saída, causando codificação errada. Agora nesse caso é feito `echo` de texto simples (sem cor, mas texto correto).
- O autodiagnóstico de caminho do IDM agora inclui `HKCU\Software\DownloadManager\ExePath` do usuário atual e fallback para diretório de instalação padrão, reduzindo falsos positivos quando o IDM está instalado mas falta `InstallFolder` no HKLM.

### Alterações
- **Entrada grandemente simplificada**: os quatro scripts antigos `TestScript.cmd` / `QuickActivate.cmd` / `NormalActivate.cmd` / `ResetActivation.cmd` foram fundidos em um único `IniciarAtivacao.cmd`. Iniciantes só precisam clicar duas vezes: elevação automática → autodiagnóstico → menu `IAS.cmd` (Congelar / Ativar / Redefinir / Baixar / Ajuda) à escolha.
- Versão do `IAS.cmd` incrementada para `1.3.6` (lógica de ativação principal inalterada).

### Documentação
- **Ajuste da recomendação**: tutorial agora prioriza `[2]` Ativar no menu, com `[1]` Congelar como "alternativa quando ainda mostrar não registrado após ativar".
- README, `llms.txt`, `ARCHITECTURE.md`, `docs/README.md` e modelos de Issue todos atualizados para modelo "entrada única `IniciarAtivacao.cmd`".
- `Instrucoes.txt` agora usa codificação UTF-8 (com BOM) para corrigir possíveis caracteres incorretos no Bloco de Notas moderno do Windows.

### Lançamento
- Adicionado `release/IDM-Activation-Script-v1.3.6.zip` e arquivo de checksum `.sha256` correspondente.

---

## v1.3.5 — 2026-05-25

### Correções
- Corrigida análise de saída `chcp`: o Windows mantém um espaço antes do número da página de código, fazendo com que o valor real 65001 seja detectado incorretamente como "página de código não é 65001". Agora o espaço é removido antes da detecção para evitar falso positivo do autodiagnóstico para CP65001.

### Documentação
- README FAQ adicionou explicação "IDM abre sozinho", distinguindo comportamento de verificação breve do script, ícone na bandeja do IDM / itens de inicialização e situações que precisam de logs complementares para diagnóstico.
- Adicionado `docs/release-notes-v1.3.5.md`, registrando esta correção de execução e método de verificação.

### Lançamento
- Adicionado `release/IDM-Activation-Script-v1.3.5.zip` e arquivo de checksum SHA256 correspondente.

---

## v1.3.4 — 2026-05-19

### Documentação
- **Adicionado `llms.txt`**: índice de projeto refinado para mecanismos de busca por IA como ChatGPT / Claude / Perplexity / Gemini, cobrindo o que pode / não pode fazer / perguntas comuns / termos de busca de cauda longa.
- **Adicionado bloco de resumo em inglês no topo do README**: voltado para tráfego de busca em inglês, listando claramente os três modos de ativação e diferenças do upstream.
- **Adicionada linha de navegação Release / llms.txt / Changelog / Issues no topo do README**.

### Lançamento
- Atualização especial de documentação, **scripts e pacote compactado não foram alterados**, ainda usando `release/IDM-Activation-Script-v1.3.3.zip` da v1.3.3 como artefato de execução. Tag `v1.3.4` marca apenas esta atualização de documentação.
- Usuários já na v1.3.3 **não precisam baixar novamente**.

---

## v1.3.3 — 2026-04-27

### Documentação
- README adicionou seção "Busca e Resumo para IA", explicando mais diretamente o que o projeto é, quais problemas resolve e qual script executar primeiro, para facilitar a compreensão por usuários iniciantes e mecanismos de busca por IA.
- Seção de download rápido atualizada para `release/IDM-Activation-Script-v1.3.3.zip`, com instruções de verificação SHA256 atualizadas.

### Lançamento
- Adicionado `release/IDM-Activation-Script-v1.3.3.zip` e arquivo de checksum `.sha256` correspondente.
- Esta versão não altera a lógica principal do script; o valor principal é facilitar que usuários encontrem o projeto, entendam como usar e saibam como verificar a integridade do arquivo após download.

---

## v1.3.2 — 2026-04-27

### Documentação
- Adicionada na seção de licença do README nota sobre o projeto upstream, deixando claro que esta versão é mantida de forma independente neste repositório.

### Lançamento
- Adicionado arquivo de checksum SHA256 para pacote de lançamento antigo v1.3, para usuários verificarem integridade de versões históricas.

---

## v1.3.1 — 2026-04-21

### Novo
- `.github/ISSUE_TEMPLATE/bug_report.yml`: modelo estruturado de relato de Bug, obrigando versão do Windows, versão do IDM e saída do `IniciarAtivacao.cmd`, reduzindo custo de diagnóstico.
- `.github/ISSUE_TEMPLATE/help.yml`: modelo de ajuda de uso / perguntas de iniciantes, reduzindo barreira de feedback para o cenário "não é um bug mas não sei usar".
- `.github/ISSUE_TEMPLATE/config.yml`: desabilita Issues em branco, orienta usuários a verificar FAQ e CHANGELOG primeiro.
- `CHANGELOG.md`: separa o histórico de versões do README / release-notes em fonte única.
- README adicionou seção "Download Rápido" apontando para a página GitHub Releases e links diretos do repositório.
- README adicionou subseção "Leitura Obrigatória Antes da Primeira Execução", alertando sobre popups de primeira execução de UAC / SmartScreen / falsos positivos de antivírus.

### Alterações
- `IniciarAtivacao.cmd`: imprime claramente "**Primeira verificação com falha**" no final do script e âncora de seção README sugerida para consulta.
- `IAS.cmd`: reescreveu chamada de elevação PowerShell para usar aspas estritas `-FilePath`, corrigindo falha de elevação automática quando o caminho contém aspas simples ou caracteres especiais.
- `Instrucoes.txt`: simplificado para "guia de três passos ultra-simples + ponteiros de FAQ"; "recomenda executar como administrador" alterado para aviso obrigatório de **leitura obrigatória**, e adicionada lista de popups de primeira execução.
- `README.md`:
  - FAQ adicionou quatro entradas: Win11 24H2, bloqueio de proteção em nuvem do Defender, política WDAC/AppLocker, compatibilidade com IDM 6.42+;
  - Parágrafo "Versão e Manutenção" atualizado para v1.3.1;
  - Tabela de arquivos inclui entradas de ponto de entrada;
  - Linha de tabela de requisitos do sistema de "codificação" simplificada para "sem necessidade de configuração manual";
  - "Método 2: Linha de Comando" colapsado em `<details>` para que iniciantes focalizem no "Método 1: Interface Gráfica".
- `IAS.cmd`: adicionado bloco de comentário "navegação de código" no cabeçalho do script, listando intervalos de linha aproximados de segmentos de código principais como análise de parâmetros, detecção de ambiente, ativação/congelamento/redefinição para facilitar manutenção futura.

### Correções
- Problema de erro de sintaxe do PowerShell `Start-Process` quando o caminho `%~f0` contém aspas simples em `IniciarAtivacao.cmd`.

### Documentação
- `SECURITY.md` totalmente traduzido para PT-BR, cobrindo canais de relato privado, pontos de informação e processo de tratamento.
- Pacote de lançamento `release/IDM-Activation-Script-v1.3.1.zip` reempacotado contendo documentação mais recente.

### CI
- `.github/workflows/ci.yml` adicionou um passo de smoke probe `IAS.cmd /silent`: chama `IAS.cmd /silent` (sem parâmetros de ação `/frz` `/act` `/res`) no `windows-latest`, afirma código de saída `2`, verificando que o caminho mais curto do script de inicialização à análise de parâmetros funciona normalmente, prevenindo regressões de sintaxe de entrar no branch principal.

---

## v1.3 — 2025-12-09

### Novo
- `IAS.cmd` suporta parâmetros `/silent` e `/log=<caminho>`, podendo suprimir interação de menu e registrar log de execução em cenários não assistidos.
- `IniciarAtivacao.cmd` passa os mesmos parâmetros.
- Verificações de ambiente expandidas para 10 itens, código de saída resumido por bit para análise automatizada.

### CI
- Adicionado GitHub Actions (Windows runner) executando `tools/validate.ps1`, forçando `.cmd`/`.txt` a manter codificação UTF-8 e terminações de linha CRLF, e detectando disponibilidade de sintaxe `cmd.exe`.

### Documentação
- Adicionada descrição do fluxo de execução e rascunho do plano de smoke para v1.3.

---

## v1.2 — 2024-10-05

### Novo
- `IniciarAtivacao.cmd` (atalho do modo de congelamento), `Instrucoes.txt` (guia de início rápido).
- Verificações de ambiente: serviço Null, modo de linguagem do PowerShell e detecção de porta TCP, retornando código de saída diferente de zero em falha.

### Alterações
- Forçado `chcp 65001` na inicialização do script e interações principais, restaurando página de código após `cls`, garantindo exibição correta do texto em PT-BR no CMD.
- Menu principal e mensagens em PT-BR, mantendo três modos: Congelar / Ativar / Redefinir.
- Mantido backup automático de registro, detecção de rede e bloqueio de CLSID.

### Correções
- `IniciarAtivacao.cmd` instrui elevação manual quando PowerShell está ausente e passa o código de retorno do IAS para cima.
- Batch auxiliar e texto todos unificados em codificação UTF-8 para garantir sem caracteres incorretos no CMD.

---

## Versões Mais Antigas

As mudanças de versões mais antigas estão espalhadas no histórico de commits e não são rastreadas individualmente. Use `git log --oneline` para ver a linha do tempo completa.
