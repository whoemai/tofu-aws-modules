<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [tls_certificate.issuer](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id_list"></a> [client\_id\_list](#input\_client\_id\_list) | (Optional) List of client IDs (audiences) registered with the identity provider. | `list(string)` | `["sts.amazonaws.com"]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of tags for the IAM OIDC provider. | `map(string)` | `{}` | no |
| <a name="input_thumbprint_list"></a> [thumbprint\_list](#input\_thumbprint\_list) | (Optional) Thumbprints of the identity provider's server certificate(s). Derived from the issuer's certificate when null. | `list(string)` | `null` | no |
| <a name="input_url"></a> [url](#input\_url) | (Required, Forces new resource) URL of the identity provider, without a trailing slash. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->
