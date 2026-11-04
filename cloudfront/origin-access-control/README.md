# cloudfront/origin-access-control

Cria **um** Origin Access Control (`aws_cloudfront_origin_access_control`) — a credencial que
o CloudFront usa pra assinar a request quando busca conteúdo numa origem privada (S3,
MediaStore, Lambda URL, MediaPackage v2). Substitui o OAI legado.

## Uso

```hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::ssh://git@github.com/whoemai/tofu-aws-modules.git//cloudfront/origin-access-control?ref=v0.5.0"
}

inputs = {
  name        = "app-frontdoor-s3-oac"
  description = "OAC do bucket de root-config do front-door v3"
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `name` | `string` | Sim | — | Nome do OAC, único por conta |
| `description` | `string` | Não | `null` | Descrição — o nome sozinho não diz qual distribuição usa |
| `origin_type` | `string` | Não | `"s3"` | `s3`, `mediastore`, `lambda` ou `mediapackagev2` |
| `signing_behavior` | `string` | Não | `"always"` | `always`, `never` ou `no-override` |
| `signing_protocol` | `string` | Não | `"sigv4"` | Único valor aceito hoje |

## Outputs

| Nome | Descrição |
|---|---|
| `id` | Input `origin_access_control_id` da origem em `cloudfront/distribution` |
| `etag` | Versão do OAC, exigida pela API fora do Terraform |

## Notas

- **O OAC não autoriza nada por si só.** Ele faz o CloudFront assinar; quem decide é a policy
  da origem. Num bucket S3, a statement precisa liberar `s3:GetObject` pro principal
  `cloudfront.amazonaws.com` com `Condition: { StringEquals: { "AWS:SourceArn": <ARN da
  distribuição> } }` — a condição é o que impede outra distribuição de ler o bucket.
- Ordem entre as units: OAC → distribuição → policy do bucket (que precisa do ARN da
  distribuição). Não é ciclo.
- Um OAC serve várias origens/distribuições, mas aí a condição `AWS:SourceArn` da policy
  precisa listar cada uma.
