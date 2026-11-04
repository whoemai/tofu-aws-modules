<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_iam_service_linked_role.aislr](https://registry.terraform.io/providers/opentofu/aws/latest/docs/resources/iam_service_linked_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_service_name"></a> [aws\_service\_name](#input\_aws\_service\_name) | (Required, Forces new resource) The AWS service to which this role is attached, formatted as a service URL without the protocol prefix (e.g. spot.amazonaws.com). | `string` | n/a | yes |
| <a name="input_custom_suffix"></a> [custom\_suffix](#input\_custom\_suffix) | (Optional, Forces new resource) Additional string appended to the role name. Support varies by service. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the role. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of tags for the IAM role. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_path"></a> [path](#output\_path) | n/a |
| <a name="output_unique_id"></a> [unique\_id](#output\_unique\_id) | n/a |
<!-- END_TF_DOCS -->
