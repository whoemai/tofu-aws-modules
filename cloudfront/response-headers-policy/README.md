# cloudfront/response-headers-policy

Cria **uma** Response Headers Policy (`aws_cloudfront_response_headers_policy`) — o
conjunto de headers CORS/segurança que um `ordered_cache_behavior` ou
`default_cache_behavior` do `cloudfront/cloudfront-distribution` injeta na resposta,
via `response_headers_policy_id`.

Os dois inputs (`cors_config`, `security_headers_config`) espelham 1:1 os blocos do
provider — nenhum campo vira toggle bool nem valor fixo escondido no módulo. Isso é
proposital: uma policy nova pode legitimamente combinar campos que outra não usa (ex.:
CSP sem CORS, ou HSTS sem `content_type_options`), e um wrapper que só expõe metade
do schema trava esse caso.

## Uso

```hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//cloudfront/response-headers-policy"
}

inputs = {
  name    = "app-frontdoor"
  comment = "CORS + security headers básicos do front-door (projeto)"

  cors_config = {
    access_control_allow_credentials = false
    access_control_allow_headers     = ["*"]
    access_control_allow_methods     = ["GET", "HEAD", "OPTIONS"]
    access_control_allow_origins     = ["https://*.app.example.com"]
    origin_override                  = true
  }

  security_headers_config = {
    content_type_options = { override = true }
    referrer_policy = {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }
    strict_transport_security = {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
  }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `name` | `string` | Sim | — | Nome da policy, único por conta+região |
| `comment` | `string` | Não | `null` | Aparece no console — o nome sozinho não diz quem usa |
| `cors_config` | `object` | Não | `null` | Bloco CORS — `null` omite o bloco inteiro na policy |
| `security_headers_config` | `object` | Não | `null` | Sub-blocos de security headers — cada um `null` omite aquele header específico |

## Outputs

| Nome | Descrição |
|---|---|
| `id` | Input `response_headers_policy_id` do behavior em `cloudfront/cloudfront-distribution` |
| `etag` | Versão da policy, exigida pela API fora do Terraform |

## Notas

- `access_control_allow_origins` não aceita wildcard solto (`*.dominio.com`) da forma
  que o `Access-Control-Allow-Origin` do HTTP normalmente permitiria — CloudFront aceita
  padrões com `*` no meio (ex. `https://*.app.example.com`), mas o comportamento
  exato (múltiplas origins vs. uma só) depende de como cada viewer manda o header
  `Origin`; teste contra o domínio real antes de assumir que cobre todos os subdomínios.
- `origin_override = true` faz os headers desta policy **substituírem** os que a origem
  (S3/ALB) já mandou; `false` só preenche o que a origem não mandou.
- Uma distribuição pode ter uma policy por behavior — não precisa (nem deveria) usar a
  mesma policy pra tudo se os behaviors servem origens diferentes (S3 estático vs. ALB
  dinâmico, por exemplo).
