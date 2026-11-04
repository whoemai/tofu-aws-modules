# dynamodb-tables

Cria um conjunto de tabelas DynamoDB a partir de um mapa de definições (chave, atributos, GSIs/LSIs, TTL).

## Uso

```hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../dynamodb/tables"
}

inputs = {
  tables = {
    sessions = {
      hash_key = "id"
      attributes = [
        { name = "id", type = "S" },
      ]
    }
  }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `tables` | `map(object({...}))` | Sim | – | Mapa de tabelas: chave = nome da tabela, valor define `hash_key`, `range_key` (opcional), `attributes` (só os atributos usados em alguma chave — tabela, GSI ou LSI), `global_secondary_indexes`/`local_secondary_indexes` (opcionais) e `ttl_attribute` (opcional). Os valores devem vir do `describe-table` da conta legada, não inventados — key schema errado só aparece em runtime. |
| `point_in_time_recovery` | `bool` | Não | `false` | PITR em todas as tabelas |
| `tags` | `map(string)` | Não | `{}` | Tags aplicadas a todas as tabelas |

## Outputs

| Nome | Descrição |
|---|---|
| `table_names` | Nomes das tabelas criadas (ordenados) |
| `table_arns` | ARNs por nome — input das policies IRSA por app (`iam/irsa-app`) |

## Notas

- `PAY_PER_REQUEST` é o único `billing_mode` suportado hoje (fixo no `main.tf`) — não replica a mistura de `PROVISIONED`/`PAY_PER_REQUEST` que existe em prod.
- `point_in_time_recovery` vem desligado por default porque a massa é sintética e recriável pelo job de seed.
- `non_key_attributes` só é enviado pra AWS quando `projection_type = "INCLUDE"` (fora disso a AWS rejeita o campo, mesmo que preenchido).
- `deletion_protection_enabled` é sempre `false` — requisito pro `run --all destroy`/`apply` funcionar sem intervenção manual.
