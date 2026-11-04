<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) The user's name. The name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-\_.. User names are not distinguished by case. For example, you cannot create users named both TESTUSER and testuser. | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | (Optional, default /) Path in which to create the user. | `string` | `"/"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value map of tags for the IAM user | `map(string)` | `{}` | no |

## Outputs

Attach a policy separately via `iam/policy` with `user_name` set to this module's `name` output.

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | n/a |
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_secret"></a> [secret](#output\_secret) | n/a (sensitive) |
| <a name="output_unique_id"></a> [unique\_id](#output\_unique\_id) | n/a |
<!-- END_TF_DOCS -->