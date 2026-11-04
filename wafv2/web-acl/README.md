# wafv2/web-acl

Cria **uma** WebACL WAFv2 (`aws_wafv2_web_acl`) com AWS Managed Rules. Não faz associação:
CloudFront recebe o ARN no próprio recurso da distribuição (`web_acl_id`); ALB/API Gateway
precisam de um `aws_wafv2_web_acl_association`, que ainda não tem módulo.

## Uso

```hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::ssh://git@github.com/whoemai/tofu-aws-modules.git//wafv2/web-acl?ref=v0.5.0"
}

inputs = {
  name        = "app-frontdoor-cf"
  description = "WebACL do front-door v3"
  scope       = "CLOUDFRONT"

  managed_rule_groups = [
    { name = "AWSManagedRulesCommonRuleSet" },
    { name = "AWSManagedRulesKnownBadInputsRuleSet" },
    { name = "AWSManagedRulesAmazonIpReputationList" },
  ]
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `name` | `string` | Sim | — | Nome da WebACL; vira também o `metric_name` |
| `description` | `string` | Não | `null` | Descrição |
| `scope` | `string` | Não | `"CLOUDFRONT"` | `CLOUDFRONT` (só us-east-1) ou `REGIONAL` |
| `default_action` | `string` | Não | `"allow"` | O que fazer com request sem match |
| `managed_rule_groups` | `list(object)` | Não | `[]` | `name`, `vendor_name`, `override_action`, `count_rules` (rules do grupo rebaixadas pra `count`) — ordem da lista = `priority` |
| `label_block_rules` | `list(object)` | Não | `[]` | `name`, `label`, `except_uri_regex` — bloqueia request com o label, exceto URI que casa o regex. Priority depois de todos os managed groups |
| `cloudwatch_metrics_enabled` | `bool` | Não | `true` | Métricas por rule no CloudWatch |
| `sampled_requests_enabled` | `bool` | Não | `true` | Amostra das requests que casaram |
| `tags` | `map(string)` | Não | `{}` | Tags adicionais |

## Outputs

| Nome | Descrição |
|---|---|
| `arn` | O que a distribuição (`web_acl_id`) e o association esperam |
| `id` | ID — junto de nome e scope, é o que o `terraform import` pede |
| `capacity` | WCU consumida pelas rules |

## Notas

- **Scope `CLOUDFRONT` só existe em us-east-1.** A unit precisa de provider apontando pra lá,
  independentemente da região do resto do ambiente. Scope `REGIONAL` fica na região do alvo.
- **`arn` e não `id`** na distribuição: o argumento `web_acl_id` do CloudFront tem nome de WAF
  Classic, mas com WAFv2 espera o ARN. Passar o id falha com `WAFInvalidParameterException`.
- A `priority` vem do índice da lista; o `for_each` é chaveado pelo **nome** do rule group,
  então reordenar renumera as priorities sem recriar rule nenhuma.
- `override_action = "count"` é o caminho pra subir uma regra nova sem risco: ela conta o match
  e deixa passar, e as métricas do CloudWatch mostram o que teria sido bloqueado.
- `count_rules` trata falso-positivo de **uma** rule sem desarmar o grupo — ex.:
  `{ name = "AWSManagedRulesCommonRuleSet", count_rules = ["SizeRestrictions_BODY"] }` libera
  body > 8 KB (POST de relatório/upload) e mantém XSS/LFI/etc. bloqueando.
- Exceção de falso-positivo **por rota**: ponha a rule em `count_rules` (ela só emite o label)
  e re-bloqueie com `label_block_rules` fora das rotas liberadas — ex.: binário de imagem em
  multipart dispara `CrossSiteScripting_BODY`:
  ```hcl
  label_block_rules = [{
    name             = "block-xss-body-except-upload"
    label            = "awswaf:managed:aws:core-rule-set:CrossSiteScripting_Body"
    except_uri_regex = "^/viajor/api/v1/despesas/[^/]+/imagem/[^/]+/idSolicitacao/[^/]+/processar$"
  }]
  ```
- Fora isso, só managed rule groups. Rule custom de outro tipo (rate limit, IP set) ainda não
  está no módulo.
- Teto default de 1500 WCU por WebACL (aumentável por ticket) — passar disso reprova o apply.
  O `capacity` do output é o que já está sendo consumido.
