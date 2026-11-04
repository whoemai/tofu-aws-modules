# rds-instance

Cria uma instância RDS (MySQL ou Postgres) multi-database, com SG, subnet group, parameter group, log groups de export e a credencial master publicada no Secrets Manager.

## Uso

```hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../rds/instance"
}

inputs = {
  identifier         = "projeto-mysql"
  engine             = "mysql"
  engine_version     = "8.4.10"
  master_username    = "root"
  master_secret_name = "projeto/rds/mysql/master"
  vpc_id             = "vpc-0123456789abcdef0" # normalmente vem de dependency.network.outputs.vpc_id
  subnet_ids         = ["subnet-0aaa", "subnet-0bbb"] # normalmente vem de dependency.network.outputs.private_subnet_ids
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| identifier | string | sim | - | Identificador da instância — também nomeia SG, subnet group e parameter group |
| engine | string | sim | - | `"mysql"` ou `"postgres"` — define a porta e a família do parameter group |
| engine_version | string | sim | - | Versão exata da engine (deve bater com a de prod) |
| instance_class | string | não | `"db.t4g.medium"` | Classe da instância |
| allocated_storage | number | não | `50` | Storage inicial em GB |
| max_allocated_storage | number | não | `100` | Teto do autoscaling de storage em GB (`0` desliga) |
| database_name | string | não | `null` | Database criado junto com a instância; os demais nascem do seed dentro do cluster |
| master_username | string | sim | - | Usuário master (`root` no MySQL, `postgres` no Postgres) |
| master_secret_name | string | sim | - | Nome (estável) do secret no Secrets Manager com a credencial master |
| vpc_id | string | sim | - | VPC onde o SG do banco é criado |
| subnet_ids | list(string) | sim | - | Subnets privadas do subnet group |
| allowed_security_group_ids | list(string) | não | `[]` | SGs que podem abrir conexão no banco (ex. SG dos nodes do EKS) |
| allowed_cidr_blocks | list(string) | não | `[]` | CIDRs extras liberados na porta do banco, quando SG não resolver |
| parameters | list(object({ name, value, apply_method })) | não | `[]` | Parâmetros do parameter group |
| parameter_group_family | string | não | `null` | Família do parameter group; vazio = derivada de `engine`+`engine_version` |
| backup_retention_period | number | não | `1` | Dias de retenção de backup automático |
| dns_cname | string | não | `null` | Hostname estável usado pelos apps — só informativo, gravado no secret master |
| kms_key_id | string | não | `null` | CMK que cifra o storage e o secret master; `null` usa as chaves gerenciadas pela AWS. Mudar numa instância existente força replace |
| storage_type | string | não | `"gp3"` | Tipo de storage (`standard`, `gp2`, `gp3`, `io1`, `io2`) |
| storage_encrypted | bool | não | `true` | Cifra o storage da instância |
| multi_az | bool | não | `false` | Cria standby síncrono em outra AZ (dobra o custo de compute) |
| skip_final_snapshot | bool | não | `true` | Pula o snapshot final ao destruir a instância |
| deletion_protection | bool | não | `false` | Bloqueia destroy da instância sem desligar esta flag antes |
| copy_tags_to_snapshot | bool | não | `true` | Propaga as tags da instância pros snapshots |
| auto_minor_version_upgrade | bool | não | `false` | Aplica minor version upgrade automaticamente na maintenance window |
| performance_insights_enabled | bool | não | `false` | Habilita Performance Insights |
| monitoring_interval | number | não | `0` | Intervalo (segundos) do Enhanced Monitoring — `0`, `1`, `5`, `10`, `15`, `30` ou `60` |
| apply_immediately | bool | não | `true` | Aplica mudanças de configuração imediatamente em vez de esperar a maintenance window |
| enabled_cloudwatch_logs_exports | list(string) | não | `[]` | Tipos de log exportados pro CloudWatch (depende da engine) |
| cloudwatch_logs_retention_days | number | não | `30` | Retenção dos log groups criados pelo módulo |
| iam_database_authentication_enabled | bool | não | `false` | Habilita autenticação por token IAM além da senha |
| tags | map(string) | não | `{}` | Tags aplicadas aos recursos do módulo |

## Outputs

| Nome | Descrição |
|---|---|
| identifier | Identificador da instância (mesmo valor de `var.identifier`) |
| address | Hostname do endpoint (sem porta) — alvo do CNAME em `route53/records` |
| endpoint | Endpoint completo host:porta |
| port | Porta da instância (5432 Postgres / 3306 MySQL, derivada da engine) |
| security_group_id | SG do banco — útil pra liberar outra origem sem mexer no módulo |
| master_secret_arn | ARN do secret com a credencial master — input da policy do job de seed |
| master_secret_name | Nome do secret master — é o que o ExternalSecret/seed referencia (nome, nunca ARN) |

## Notas

- A senha master é gerada via `random_password` e publicada no Secrets Manager com nome estável (`master_secret_name`), em vez de usar `manage_master_user_password`: o secret auto-gerado pela RDS tem nome com sufixo aleatório que muda a cada recriação da instância.
- Os log groups do CloudWatch são criados explicitamente ANTES da instância (`depends_on`), pra não herdar a retenção `Never expire` que a RDS aplicaria se criasse o group sozinha no primeiro export.
- É um wrapper direto de `aws_db_instance` (não usa módulo da comunidade) — decisão de manter o recurso explícito em vez de escondê-lo atrás de um módulo genérico.
