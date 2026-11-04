# vpc/security-group

Cria **um** `aws_security_group` com as regras dele (`aws_vpc_security_group_ingress_rule` /
`_egress_rule`, uma por entrada de mapa). Existe pra que módulo de recurso — RDS, ElastiCache,
ALB — não crie SG por dentro: o recurso recebe `security_group_ids` e o grupo tem unit própria.

Regra e SG no mesmo módulo, e não em dois, por dependência de ciclo de vida: o SG tem
`create_before_destroy`, e regra vivendo em outro state continuaria apontando pro id antigo — o
grupo novo nasceria sem regra nenhuma, derrubando o tráfego sem que ninguém tenha pedido
mudança de rede.

## Uso

```hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::ssh://git@github.com/whoemai/tofu-aws-modules.git//vpc/security-group?ref=v0.6.0"
}

dependency "network" { config_path = "../../vpc/network" }
dependency "eks"     { config_path = "../../eks/cluster" }

inputs = {
  name        = "projeto-redis"
  description = "Acesso ao Redis projeto-redis a partir dos nos do EKS"
  vpc_id      = dependency.network.outputs.vpc_id

  ingress_rules = {
    from-eks = {
      from_port                    = 6379
      to_port                      = 6379
      referenced_security_group_id = dependency.eks.outputs.cluster_primary_security_group_id
    }
  }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `name` | `string` | Sim | — | Base do nome (vira `name_prefix`) e valor da tag `Name` |
| `description` | `string` | Sim | — | Descrição do SG — forced-new, sem acento |
| `vpc_id` | `string` | Sim | — | VPC onde o SG é criado |
| `ingress_rules` | `map(object)` | Não | `{}` | Regras de entrada; chave = rótulo estável |
| `egress_rules` | `map(object)` | Não | `{}` | Regras de saída; vazio = **sem egress** |
| `tags` | `map(string)` | Não | `{}` | Tags |

Cada regra aceita `description`, `ip_protocol` (default `"tcp"`), `from_port`, `to_port` e
**exatamente uma** origem/destino entre `cidr_ipv4`, `cidr_ipv6`, `prefix_list_id` e
`referenced_security_group_id`. As duas condições são checadas por `validation`, no plan.

## Outputs

| Nome | Descrição |
|---|---|
| `id` | O que `security_group_ids`/`vpc_security_group_ids` dos recursos esperam |
| `arn` | ARN do SG |
| `name` | Nome real, já com o sufixo do `name_prefix` |

## Notas

- **O nome tem sufixo aleatório.** `name_prefix` é obrigatório junto de
  `create_before_destroy`: com nome fixo o replace falha em `InvalidGroup.Duplicate`, porque o
  grupo novo é criado antes de o antigo sair. Quem procura no console procura pela tag `Name`.
- **`egress_rules = {}` é SG sem saída.** A AWS cria um allow-all ao criar o grupo e o provider
  remove esse default — comportamento documentado do `aws_security_group`. Cache e banco não
  precisam de egress; qualquer coisa que faça chamada de saída precisa declarar.
- **A chave do mapa é o identificador da regra no state.** Trocar a chave recria aquela regra;
  reordenar o mapa não mexe em nada. Rótulo descritivo (`from-eks`, `from-vpn`) vale mais que
  índice numérico.
- **`description` do SG é forced-new.** Editar texto de descrição recria o grupo (e, por
  tabela, as regras dele) — o replace é barato, mas o SG novo tem id diferente e quem guardou
  o id fora do Terraform quebra.
- Com Cilium, o SG que os pods realmente usam é o `cluster_primary_security_group_id`, não o
  `node_security_group_id` — ver a nota no output do `eks/cluster`.
- Import: `terragrunt import 'aws_security_group.this' <sg-id>` e, por regra,
  `terragrunt import 'aws_vpc_security_group_ingress_rule.this["from-eks"]' <sgr-id>`.
