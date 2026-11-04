# dns-records

Cria um registro DNS numa hosted zone já existente — um `aws_route53_record` por chamada do módulo, mesma convenção de 1-recurso-por-unidade-terragrunt do resto do repo. Cobre tanto o caso simples de infra (CNAME de RDS/Redis, endpoint que os apps consomem via `.properties`) quanto alias (ALB/NLB, CloudFront, S3 website, outra hosted zone) e routing policies (weighted, failover, latency, geolocation, geoproximity, multivalue, CIDR) — não é específico de um projeto ou ambiente.

## Uso

```hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//route53/records"
}

inputs = {
  zone_id = dependency.hosted_zone.outputs.zone_id # normalmente vem de dependency.hosted_zone.outputs.zone_id
  name    = basename(get_terragrunt_dir())

  records = ["meu-rds-endpoint.abcdefghijkl.us-east-1.rds.amazonaws.com"]
}
```

Alias pra ALB (ttl/records não entram, o provider rejeita junto de alias):

```hcl
inputs = {
  zone_id = dependency.hosted_zone.outputs.zone_id
  name    = basename(get_terragrunt_dir())
  type    = "A"

  alias = {
    name    = "meu-alb-1234567890.us-east-1.elb.amazonaws.com"
    zone_id = "Z35SXDOTRQ7X7K" # zone_id do ALB, não da hosted zone
  }
}
```

Weighted routing (precisa de `set_identifier`):

```hcl
inputs = {
  zone_id         = dependency.hosted_zone.outputs.zone_id
  name            = basename(get_terragrunt_dir())
  records         = ["api-blue.internal"]
  set_identifier  = "blue"

  weighted_routing_policy = { weight = 90 }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| zone_id | string | Sim | — | ID da hosted zone onde o registro é criado |
| name | string | Sim | — | Nome do registro, relativo à zona (ex. `"db"`) ou FQDN |
| type | string | Não | `"CNAME"` | Tipo do registro (A, AAAA, CNAME, TXT, MX, ...) |
| records | list(string) | Não* | — | Valores do registro. *Obrigatório se `alias` não for definido |
| ttl | number | Não | `60` | Ignorado se `alias` for definido |
| alias | object | Não | — | `{ name, zone_id, evaluate_target_health = true }` — alvo alias (ALB/NLB, CloudFront, S3 website, outra zone). Conflita com `records`/`ttl` |
| set_identifier | string | Não* | — | *Obrigatório junto de qualquer routing policy abaixo |
| health_check_id | string | Não | — | Health check associado ao registro |
| weighted_routing_policy | object | Não | — | `{ weight }` |
| failover_routing_policy | object | Não | — | `{ type }` (`PRIMARY` ou `SECONDARY`) |
| latency_routing_policy | object | Não | — | `{ region }` |
| geolocation_routing_policy | object | Não | — | `{ continent, country, subdivision }` (continent ou country obrigatório) |
| geoproximity_routing_policy | object | Não | — | `{ aws_region, bias, local_zone_group, coordinates = { latitude, longitude } }` |
| multivalue_answer_routing_policy | bool | Não | — | `true` pra resposta multivalue |
| cidr_routing_policy | object | Não | — | `{ collection_id, location_name }` |
| allow_overwrite | bool | Não | `true` | Permite sobrescrever registro pré-existente com mesmo nome/tipo. `false` pra detecção estrita de conflito |

Routing policies são mutuamente exclusivas entre si — essa regra é do provider AWS, não é validada pelo módulo.

## Outputs

| Nome | Descrição |
|---|---|
| fqdn | FQDN do registro criado — é o hostname que entra no `.properties` do app |

## Notas
- Em registro alias, `ttl`/`records` são setados como `null` (equivalente a omitir o argumento) porque o provider rejeita alias junto de `ttl`/`records`.
- `allow_overwrite` default `true` porque o uso original deste módulo é registro de propriedade do próprio stack, onde uma recriação pode deixar um registro órfão pra trás. Outro projeto pode setar `false`.
- Não confundir com o external-dns: aquele publica hostnames de Ingress a partir do ALB; este módulo cria registros DNS explícitos, que o external-dns não conhece nem deve mexer.
