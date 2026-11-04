# secrets-manager/secret

Cria um secret no Secrets Manager com um valor placeholder inicial, para ser consumido por `ExternalSecret` (ESO) e ter o valor real preenchido fora do Terraform.

Uma unit por secret — mesma lógica do `kms/key` e do `route53/record`. Substitui o antigo `secrets-manager/secrets` (map, removido por falta de consumidor).

Preencher, rotacionar e auditar valor real: [`documentos/RUNBOOK-segredos.md`](../../documentos/RUNBOOK-segredos.md).

## Uso

```hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../secrets-manager/secret"
}

inputs = {
  name        = "projeto/rds/mysql/master"
  description = "Credencial master do RDS MySQL"
}
```

```hcl
# Secret cujo consumidor exige forma válida no boot: declare a FORMA aqui e use
# `__PLACEHOLDER__` nos campos sensíveis — o módulo troca cada token pelo placeholder.
inputs = {
  name = "prod/exemplo"

  initial_value = jsonencode({
    "api-key" = "__PLACEHOLDER__"
    "host"    = "smtp.exemplo.com" # config real, não segredo
  })
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `name` | `string` | sim | - | Nome exato do secret (igual ao de prod, ex. `"Viajante"`, `"prod/autenticador"`) |
| `description` | `string` | não | `null` | Descrição do secret |
| `initial_value` | `string` | não | `null` | Valor inicial opcional; string JSON/properties de placeholder quando o app exige forma válida no boot |
| `tags` | `map(string)` | não | `{}` | Tags do secret |
| `placeholder_prefix` | `string` | não | `"PREENCHER-FORA-DO-TERRAFORM"` | Prefixo do placeholder. O valor final é `<prefixo>-<24 chars aleatórios>` |
| `placeholder_token` | `string` | não | `"__PLACEHOLDER__"` | Marcador que o módulo troca pelo placeholder dentro de `initial_value` |

## Outputs

| Nome | Descrição |
|---|---|
| `name` | Nome do secret criado |
| `arn` | ARN do secret — input das policies IRSA (`iam/irsa-app`) |

## O placeholder é prefixo + aleatório, e o token cobre valor estruturado

O raciocínio completo está no [README do `ssm/parameters`](../../ssm/parameters/README.md#o-placeholder-é-prefixo--aleatório-não-uma-constante): placeholder constante e versionado no GitHub é credencial pública esperando alguém usá-la como valor real. Aqui o valor plano nasce `<placeholder_prefix>-<24 chars aleatórios>`.

`initial_value` existe porque vários secrets deste ambiente são lidos por um consumidor que exige forma válida no boot — o `start.sh` do `auth-service` extrai chave por chave com `jq -r`, e JSON inválido aborta o container antes de qualquer log. Só que declarar a forma na unit era também um jeito de reintroduzir a constante pública pela porta de trás: os valores dentro do JSON ficavam fixos no `terragrunt.hcl`.

Daí o `placeholder_token`: a unit declara a **forma** e escreve `__PLACEHOLDER__` nos campos sensíveis, e o módulo substitui cada ocorrência por `<prefixo>-<aleatório>`. Um único `replace` cobre os dois casos, sem condicional — sem `initial_value` a string é só o token, e o replace devolve o placeholder puro.

## Notas

- `recovery_window_in_days = 0` é fixo no módulo (não é variável): com janela de recuperação, um `apply` logo depois de um `destroy` falha porque o nome fica "agendado pra deleção".
- `lifecycle { ignore_changes = [secret_string] }` no `aws_secretsmanager_secret_version`: o Terraform escreve o placeholder só na criação e nunca mais sobrescreve — o valor real é preenchido fora dele. Aqui é `[secret_string]` e não `all` (ao contrário do `ssm/parameters`) porque o único atributo atualizável in-place deste recurso é `version_stages`, que vira `UpdateSecretVersionStage` e não toca no conteúdo.
- Mudar `initial_value` de um secret que já existe **não** gera diff (é justamente o que o `ignore_changes` garante). A forma nova só vale para secret recriado — o valor de um secret existente se muda com `put-secret-value`, ver o RUNBOOK.
- Os `ExternalSecret` devem referenciar o secret por **nome**, nunca por ARN: o sufixo aleatório do ARN é gerado pela AWS e muda entre contas/recriações.
