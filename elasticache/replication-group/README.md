# elasticache/replication-group

Cria **um** `aws_elasticache_replication_group` (Redis/Valkey, sem cluster mode). Só o cache: o
subnet group vem do `elasticache/subnet-group`, o security group do `vpc/security-group` e a CMK
do `kms/keys` — cada um com unit e state próprios.

Substitui o antigo `elasticache/redis`, que criava sete recursos (cache, subnet group, SG, regra
de ingress, `random_password` e o par secret + version do AUTH token).

## Uso

```hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::ssh://git@github.com/whoemai/tofu-aws-modules.git//elasticache/replication-group?ref=v0.6.0"
}

dependency "subnet_group" { config_path = "../subnet-group" }
dependency "sg"           { config_path = "../security-group" }
dependency "kms"          { config_path = "../../kms" }

inputs = {
  replication_group_id = "projeto-redis"
  description          = "Cache do ambiente projeto"
  node_type            = "cache.t4g.micro"

  subnet_group_name  = dependency.subnet_group.outputs.name
  security_group_ids = [dependency.sg.outputs.id]

  kms_key_id = dependency.kms.outputs.key_arns["projeto-cache"]
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `replication_group_id` | `string` | Sim | — | ID do grupo; até 40 caracteres, começando por letra |
| `description` | `string` | Sim | — | Campo obrigatório do recurso |
| `node_type` | `string` | Sim | — | Classe do nó |
| `subnet_group_name` | `string` | Sim | — | Output `name` do `elasticache/subnet-group` |
| `security_group_ids` | `list(string)` | Sim | — | Output `id` do `vpc/security-group` |
| `engine` | `string` | Não | `"redis"` | `redis` ou `valkey` |
| `engine_version` | `string` | Não | `"7.1"` | Major precisa combinar com o parameter group |
| `port` | `number` | Não | `6379` | Forced-new |
| `parameter_group_name` | `string` | Não | `"default.redis7"` | Default da AWS pra Redis 7 sem cluster mode |
| `num_cache_clusters` | `number` | Não | `1` | Nós do grupo (primário + réplicas) |
| `automatic_failover_enabled` | `bool` | Não | `false` | Exige 2+ nós |
| `multi_az_enabled` | `bool` | Não | `false` | Exige failover automático |
| `transit_encryption_enabled` | `bool` | Não | `false` | TLS no protocolo; pré-requisito do `auth_token` |
| `auth_token` | `string` | Não | `null` | Senha do Redis (sensível); `null` = sem AUTH |
| `at_rest_encryption_enabled` | `bool` | Não | `true` | Forced-new |
| `kms_key_id` | `string` | Não | `null` | CMK do dado em repouso; mudar força replace |
| `snapshot_retention_limit` | `number` | Não | `0` | `0` desliga o backup automático |
| `apply_immediately` | `bool` | Não | `true` | Aplica agora em vez de na janela |
| `auto_minor_version_upgrade` | `bool` | Não | `false` | Mantém a versão previsível |
| `tags` | `map(string)` | Não | `{}` | Tags |

## Outputs

| Nome | Descrição |
|---|---|
| `id` | ID do grupo — o que o `terraform import` pede |
| `arn` | ARN |
| `primary_endpoint_address` | Host de leitura e escrita, o que a aplicação usa |
| `reader_endpoint_address` | Endpoint de leitura; com um nó, o mesmo do primário |
| `port` | Porta da engine |
| `transit_encryption_enabled` | Se o cliente precisa falar TLS |
| `member_clusters` | Nós do grupo |

## TLS e AUTH sobem juntos

A AWS **rejeita `auth_token` sem `transit_encryption_enabled`** (`InvalidParameterCombination`):
"ligar só a senha, sem mexer no app" não existe. O módulo checa isso num `precondition`, então o
erro aparece no plan e não depois de 10 minutos de apply.

Os dois vêm desligados por default porque ligar não é mudança só de infra — cliente que fale em
texto plano e sem senha passa a ser recusado. No ambiente `projeto` isso está travado pela
aplicação: o `web-app` só expõe `app.redis.{enabled,host,port}`, sem propriedade de
SSL nem de senha nesse namespace, então TLS+AUTH derrubam o cache até o código do app suportar.
Sem AUTH, a autorização é puramente de rede: qualquer pod que alcance o SG lê e escreve o cache
inteiro.

> ⚠️ **Gap conhecido:** gerar a senha e publicá-la num secret era trabalho do `elasticache/redis`
> (`random_password` + `aws_secretsmanager_secret` + `_version`, com o endpoint dentro do JSON) e
> **ainda não tem onde morar**. O `secrets-manager/secrets` cria o secret com placeholder e
> `ignore_changes = [secret_string]` — ele não devolve valor pra outra unit consumir. Enquanto não
> existir um módulo que gere o valor e o exponha (ou a unit ler o secret por data source),
> `transit_encryption_enabled = true` exige passar `auth_token` à mão. Nada regride hoje: o
> ambiente que consome este módulo está com TLS desligado por limite do app.

## Notas

- **`kms_key_id`, `port` e `at_rest_encryption_enabled` são forced-new.** Trocar qualquer um
  recria o grupo — a AWS não recriptografa nem troca porta in-place. Decidir isso com o cache
  vazio custa nada; depois custa o cache inteiro.
- **`num_cache_clusters = 1` é nó único.** Sem réplica, sem failover: a perda do nó é a perda do
  cache. Subir pra 2 exige `automatic_failover_enabled = true`, e `multi_az_enabled` exige o
  failover — os três andam em conjunto, e a AWS recusa a combinação incoerente no apply.
- **`snapshot_retention_limit = 0` desliga o backup.** Coerente com cache descartável; se o Redis
  virar armazenamento de sessão que não pode sumir, isso deixa de ser detalhe.
- **`apply_immediately = true` reinicia na hora.** Bom em ambiente sem tráfego, ruim em produção —
  é a diferença entre a mudança cair agora e cair na janela de manutenção.
- Import: `terragrunt import 'aws_elasticache_replication_group.this' <replication-group-id>`.
