# ssm/parameter

Cria um único parâmetro no SSM Parameter Store com um valor placeholder inicial, para ser consumido por `ExternalSecret` (ESO) e ter o valor real preenchido fora do Terraform.

Uma unit por parâmetro — mesma lógica do `secrets-manager/secret`, `kms/key` e `route53/record`. Complementa (não substitui) o [`ssm/parameters`](../parameters/README.md): aquele continua sendo o jeito certo para `managed_parameters` (configuração não sensível, vários paths numa unit só); este é só para o caso SEGREDO isolado, uma unit por path.

Preencher, rotacionar e auditar valor real: [`documentos/RUNBOOK-segredos.md`](../../documentos/RUNBOOK-segredos.md).

## Uso

```hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../ssm/parameter"
}

inputs = {
  name = "/prod/aereo-ia/db/password"
  type = "SecureString"

  tags = {
    Ambiente = "projeto"
  }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `name` | `string` | sim | - | Path completo do parâmetro (ex. `"/prod/app/db/password"`) |
| `type` | `string` | sim | - | `"String"`, `"StringList"` ou `"SecureString"` |
| `description` | `string` | não | `null` | Descrição do parâmetro. Só vale na criação (ver Notas) |
| `tier` | `string` | não | `"Standard"` | Tier do parâmetro no SSM |
| `tags` | `map(string)` | não | `{}` | Tags do parâmetro |
| `placeholder_prefix` | `string` | não | `"PREENCHER-FORA-DO-TERRAFORM"` | Prefixo do placeholder. O valor final é `<prefixo>-<24 chars aleatórios>` |

## Outputs

| Nome | Descrição |
|---|---|
| `name` | Path do parâmetro criado |
| `arn` | ARN do parâmetro — input das policies IRSA (`iam/irsa-app`) |

## Por que não usar `ssm/parameters` (map) pra tudo

`ssm/parameters` aceita um `parameters = {...}` inteiro numa unit só, com `for_each`. Funciona, mas todos os paths compartilham o mesmo state — uma unit isolada por parâmetro dá blast radius menor por `apply`/`import`/`state mv` e acompanha o padrão já adotado pro Secrets Manager (`secrets-manager/secrets`, o antigo map, foi removido por falta de consumidor em favor do `secrets-manager/secret` singular).

Use `ssm/parameters` só para `managed_parameters` (config não sensível que faz sentido agrupar, ex. os dois paths do bootstrap do Kafka) — esse caso não tem o problema de blast radius porque não é segredo.

## Notas

- `lifecycle { ignore_changes = all }`: o Terraform escreve o placeholder só na criação e nunca mais sobrescreve. Mudar `description`/`tier`/`type`/`tags` de um parâmetro já criado é no-op silencioso no plan — pra mudar de verdade é preciso recriar o parâmetro, o que apaga o valor real (confira antes com `scripts/segredos.sh status`).
- O placeholder é `<placeholder_prefix>-<24 chars aleatórios>` (`random_password`), nunca uma constante fixa — o porquê completo está no [README do `ssm/parameters`](../parameters/README.md#o-placeholder-é-prefixo--aleatório-não-uma-constante).
- Os `ExternalSecret` devem referenciar o parâmetro pelo path completo — não há ARN envolvido no lado do consumidor.
