# IDM Script de Ativação PT-BR v1.3.8 — Notas de Lançamento

- Versão: **v1.3.8** (2026-06-23)
- Tipo: revisão somente de documentação (zero mudanças em scripts de execução e pacote de lançamento)
- Pacote de lançamento de execução: ainda usa `release/IDM-Activation-Script-v1.3.7.zip` (SHA256 inalterado)

## Mudanças Desta Versão

Esta versão não modifica nenhum script; apenas corrige várias inconsistências na documentação que poderiam enganar usuários ou impedir que mecanismos de busca tradicionais e por IA entendam corretamente o projeto:

| Categoria | Problema | Tratamento |
|---|---|---|
| Atribuição upstream | Seção de licença do README citava `WindowsAddict/IDM-Activation-Script`, conflitando com o uso consistente de `lstprjct/IDM-Activation-Script` no topo do README, `llms.txt` e CHANGELOG | Unificado para `lstprjct/IDM-Activation-Script`, removida data de arquivamento não verificável, evitando "fontes de fatos" contraditórias sendo indexadas |
| Guia para iniciantes | `docs/README.md` ainda dizia "iniciantes devem selecionar `[1]` Congelar no menu", o oposto da recomendação real do script desde v1.3.6 (padrão é `[2]` Ativar, `[1]` apenas como alternativa) | Alinhado para prioridade do `[2]` Ativar, exemplo de comando atualizado para `IAS.cmd /act` |
| Índice de documentação | Lista de notas de lançamento em `docs/README.md` e enumeração `docs/` em `ARCHITECTURE.md` listavam apenas até v1.3.4/v1.3.5 | Adicionadas entradas v1.3.5–v1.3.7, tornando o índice consistente com os arquivos reais |

## Relação com v1.3.7

v1.3.8 **não altera nenhum script ou pacote de lançamento**; o comportamento de `IAS.cmd` / `IniciarAtivacao.cmd` é idêntico ao v1.3.7, o pacote de execução ainda é `IDM-Activation-Script-v1.3.7.zip`. Usuários já na v1.3.7 **não precisam baixar o script novamente**; esta versão apenas torna a documentação do repositório consistente entre arquivos e com posicionamento mais claro.

## Sugestões de Verificação

```powershell
.\tools\validate.ps1
Get-FileHash .\release\IDM-Activation-Script-v1.3.7.zip -Algorithm SHA256
```
