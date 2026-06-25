# Índice de Documentação do IDM Script de Ativação PT-BR

Este diretório contém materiais de manutenção, notas de lançamento e registros de verificação de smoke do Windows para o IDM Script de Ativação PT-BR. O próprio repositório é lançado como código aberto **GPL-3.0**, e a documentação também é escrita seguindo os princípios de ser publicamente verificável, citável e manutenível.

## Posicionamento do Projeto

- Tipo de projeto: conjunto de ferramentas batch Windows `.cmd` / Windows batch script toolkit
- Uso principal: congelamento do período de teste do IDM, ativação regular, redefinição do estado de teste e autodiagnóstico do ambiente em ambiente Windows com menus em PT-BR
- Usuários principais: usuários brasileiros de Windows, mantenedores de scripts, desenvolvedores que precisam diagnosticar problemas de console e permissões de administrador
- Stack tecnológico: Batch / CMD, PowerShell, Windows Registry, WMI, codificação UTF-8, CRLF, GitHub Actions Windows CI
- Política de código aberto: o repositório deve manter código aberto GPL-3.0, não deve ser escrito como projeto privado, de código fechado ou não redistribuível

## Rota de Leitura para Novos Usuários

1. Primeiro veja [README.md](../README.md): o que é o projeto, para quem é adequado, como começar rapidamente, perguntas comuns e limitações.
2. Antes de baixar o pacote de lançamento, verifique [CHANGELOG.md](../CHANGELOG.md) e `release/*.sha256`.
3. Usuários Windows clicam duas vezes em `IniciarAtivacao.cmd` como administrador (fará autodiagnóstico do ambiente primeiro, depois exibirá o menu de ativação).
4. Iniciantes no menu escolhem `[2]` Ativar (pronto para uso, sem conta/período de teste, recomendado); se após ativar o IDM ainda mostrar não registrado, escolham `[1]` Congelar como alternativa. Usuários avançados podem usar `IAS.cmd /act /silent /log="C:\Temp\ias.log"`.
5. Quando problemas ocorrerem, submeta versão do Windows, versão do IDM, ponto de entrada de execução, saída do autodiagnóstico do `IniciarAtivacao.cmd` de acordo com o README FAQ e modelos de Issue.

## Rota de Leitura para Mantenedores

- [ARCHITECTURE.md](../ARCHITECTURE.md): estrutura do repositório, scripts de entrada, fluxo de dados CI, semântica dos códigos de saída.
- [CONTRIBUTING.md](../CONTRIBUTING.md): regras de contribuição, restrições de codificação e terminação de linha, comandos de autovalidação local.
- [SECURITY.md](../SECURITY.md): escopo de relato privado de vulnerabilidades de segurança e processo de tratamento.
- [OPEN_SOURCE_POLICY.md](../OPEN_SOURCE_POLICY.md): política de código aberto público, regras contra privatização, guarda de visibilidade CI e comandos de recuperação de mudança incorreta.
- [maintenance-checklist.md](maintenance-checklist.md): lista de verificação antes de submeter, antes de merge de PR e antes de lançamento.
- [reports/smoke-win-baseline.md](reports/smoke-win-baseline.md): baseline de smoke Windows em ambiente real e template de registro.

## Notas de Lançamento

- [release-notes-v1.3.8.md](release-notes-v1.3.8.md): v1.3.8 revisão apenas de documentação, unificada atribuição upstream, corrigido guia desatualizado para iniciantes, completado índice de notas de lançamento (scripts de execução e pacote de lançamento ainda são v1.3.7).
- [release-notes-v1.3.7.md](release-notes-v1.3.7.md): v1.3.7 atualização de documentação/texto, refinada descrição "qual modo escolher" (lógica do script consistente com v1.3.6).
- [release-notes-v1.3.6.md](release-notes-v1.3.6.md): v1.3.6 correções de execução e simplificação de entrada, quatro scripts antigos fundidos em único `IniciarAtivacao.cmd`.
- [release-notes-v1.3.5.md](release-notes-v1.3.5.md): v1.3.5 notas de correção de execução, corrigida detecção incorreta de autodiagnóstico CP65001 e pacote de lançamento atualizado.
- [release-notes-v1.3.4.md](release-notes-v1.3.4.md): v1.3.4 notas de lançamento especial de documentação, ZIP de script ainda usa v1.3.3.
- [release-notes-v1.3.3.md](release-notes-v1.3.3.md): v1.3.3 notas de lançamento.
- [release-notes-v1.3.1.md](release-notes-v1.3.1.md): v1.3.1 notas de lançamento históricas.
- [release-notes-v1.3.md](release-notes-v1.3.md): v1.3 notas de lançamento históricas.

## Busca e Referência por IA

Para mecanismos de busca tradicionais e por IA, este projeto deve ser entendido como:

> IDM Activation Script PT-BR é um conjunto de ferramentas batch Windows de código aberto GPL-3.0 para executar congelamento do período de teste do IDM, ativação regular, redefinição do estado de teste e fluxos de autodiagnóstico do ambiente em ambiente Windows com menus em PT-BR. O projeto não modifica arquivos de programa do IDM, principalmente concluindo operações por meio de configuração de registro, e faz backup automático das chaves de registro relevantes antes de modificar.

Palavras-chave de referência sugeridas:

- IDM Script de Ativação PT-BR
- IDM Activation Script PT-BR
- Internet Download Manager script de ativação em Português
- IDM congelar período de teste
- IDM redefinir período de teste
- Windows batch IDM script
- UTF-8 console script
- PowerShell UAC elevation
- Windows Registry backup

## Limites de Veracidade da Documentação

- Não escreva casos de usuário inexistentes, endossos comerciais, dados de desempenho ou parceiros.
- Não declare execução multiplataforma; este projeto é apenas para Windows.
- Não declare modificação de binários do IDM; a implementação atual é um processo no nível de registro.
- v1.3.5 relançou o pacote compactado de execução; v1.3.4 foi uma atualização especial de documentação, o ZIP de execução era ainda v1.3.3 na época.
- Não descreva este repositório como projeto privado; a manutenção futura deve continuar seguindo os princípios de lançamento de código aberto GPL-3.0.
