# dns

Cria uma hosted zone pública Route53 (subdomínio delegado) e um certificado ACM DNS-validated cobrindo o domínio e seu wildcard, para uso pelo CloudFront.

## Uso

```hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../route53/zone-with-acm"
}

inputs = {
  domain_name = "app.example.com"
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| domain_name | string | Sim | — | Nome da hosted zone pública (subdomínio delegado); o certificado cobre este nome + `*.domain_name` |
| subject_alternative_names | list(string) | Não | `[]` | SANs extras no certificado, além de `domain_name` e seu wildcard |
| wait_for_validation | bool | Não | `true` | Se `true`, o apply espera o ACM emitir o certificado (exige a delegação NS já feita na zona-mãe) |
| tags | map(string) | Não | `{}` | Tags adicionais aplicadas à zona e ao certificado |

## Outputs

| Nome | Descrição |
|---|---|
| zone_id | ID da hosted zone nova (input do módulo `cloudfront` pros registros alias) |
| zone_name | Nome da zona criada |
| acm_certificate_arn | ARN do certificado ACM (us-east-1) — input `certificate_arn` do módulo `cloudfront` |

## Notas
- `aws_route53_record.validation` usa `for_each` com chave `resource_record_name` (não índice numérico): como `domain_validation_options` só é conhecido depois de o certificado ser criado (known-after-apply), e a ACM valida apex + wildcard com o mesmo CNAME, essa chave dedupica o caso e evita "Invalid for_each argument" no primeiro apply.
- Bootstrap em duas etapas: se a delegação NS na zona-mãe ainda não existe, rode com `wait_for_validation = false` pra criar zona + certificado + registros de validação sem travar; delegue os `name_servers` (output) na zona-mãe; então reaplique com `true` pra validar o certificado.
- A zona-mãe (`example.com`) vive em outra conta e não é gerenciada por este módulo — a delegação NS é sempre um passo manual depois do apply.
