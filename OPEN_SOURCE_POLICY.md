# Política de Código Aberto / Open Source Policy

Este repositório **deve permanecer publicamente aberto como código aberto (public + GPL-3.0)**. Não deve ser tornado privado, nem descrito como projeto de código fechado, distribuição proprietária ou não redistribuível.

## Princípios Fixos

- Visibilidade do repositório: deve ser `PUBLIC`.
- Licença: deve preservar `GPL-3.0` e o `LICENSE` na raiz.
- Método de distribuição: README, Release, `llms.txt`, docs e modelos de Issue devem ser escritos como projeto de código aberto publicamente verificável, copiável e redistribuível.
- Obras derivadas: ao redistribuir secondariamente baseado neste projeto, deve preservar o texto da licença GPL-3.0, aviso de direitos autorais e registro de modificações, e usar a mesma licença GPL ou compatível.

## Mudanças Não Permitidas

- Não torne o repositório privado.
- Não exclua o `LICENSE` nem mude o projeto para licença de código fechado.
- Não insinue no README, docs, Release ou modelos de Issue que este projeto é uma ferramenta privada, ferramenta interna ou entrega de código fechado.
- Não crie links para pacotes de lançamento de execução inexistentes, por exemplo, escrevendo versões especiais de documentação como novos artefatos ZIP.

## Salvaguardas Técnicas Adicionadas

`.github/workflows/ci.yml` contém um passo `Guard public repository visibility`. Ele lê o campo `repository.private` no evento do GitHub Actions:

- Se o repositório é público, o CI continua executando.
- Se o repositório for tornado privado, o CI falhará diretamente e solicitará que seja revertido para público.

Esta guarda não pode impedir que o proprietário mude manualmente a visibilidade nas configurações do GitHub, mas pode expor o problema imediatamente em subsequentes pushes, PRs ou CI manual, evitando que o estado de privatização seja silenciosamente ignorado.

## Tratamento Após Mudança Incorreta

Se descobrir que o repositório foi tornado privado, deve executar imediatamente:

```bash
gh repo edit SEU_USUARIO/IDM-Activation-Script-PTBR \
  --visibility public \
  --accept-visibility-change-consequences
```

Após restaurar, verifique:

```bash
gh repo view SEU_USUARIO/IDM-Activation-Script-PTBR \
  --json visibility,isArchived,description,repositoryTopics,url
```

Resultado esperado: `visibility` é `PUBLIC`, `isArchived` é `false`, Topics inclui `open-source` / `gpl-3`.
