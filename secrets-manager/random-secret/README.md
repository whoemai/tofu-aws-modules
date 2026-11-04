<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Nome exato do secret (ex. "projeto/rds/db-projeto/master") | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Descrição do secret | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | (Opcional) ARN/ID da CMK que cifra o secret. Null usa a key gerenciada aws/secretsmanager. | `string` | `null` | no |
| <a name="input_length"></a> [length](#input\_length) | Tamanho da senha gerada | `number` | `32` | no |
| <a name="input_override_special"></a> [override\_special](#input\_override\_special) | Conjunto de caracteres especiais permitidos na senha gerada | `string` | `"!#$*-_=+[]{}<>:?"` | no |
| <a name="input_password_token"></a> [password\_token](#input\_password\_token) | Marcador que o módulo troca pela senha real dentro de secret\_string\_template. | `string` | `"__PASSWORD__"` | no |
| <a name="input_secret_string_template"></a> [secret\_string\_template](#input\_secret\_string\_template) | Forma do secret\_string quando o consumidor exige uma estrutura (JSON/properties) em vez da senha pura. Use `password_token` no campo sensível, ex.: `jsonencode({ username = "admin", password = "__PASSWORD__" })`. Null grava só a senha, sem estrutura nenhuma. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags do secret | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Nome do secret criado |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN do secret |
| <a name="output_password"></a> [password](#output\_password) | Senha gerada, em texto puro. Sensível — não logar. |
<!-- END_TF_DOCS -->

## Quando usar este módulo vs `secrets-manager/secret`

- **`secrets-manager/secret`** — placeholder inerte. O secret nasce com um valor
  reconhecível (`PREENCHER-FORA-DO-TERRAFORM-<sufixo>`) que precisa ser preenchido
  fora do Terraform. Serve pra segredos de app consumidos via ESO, onde o valor real
  nunca deve passar pelo state.
- **`secrets-manager/random-secret` (este módulo)** — o valor É o segredo de verdade,
  gerado pelo próprio Terraform (`random_password`) e gravado no state. Serve pra
  credenciais que o Terraform precisa **consumir na mesma apply**, como a senha
  master de um RDS passada de uma unit pra outra via `dependency` (ex.
  `rds/rds-instance` restaurando de snapshot e resetando a senha master no restore).
