<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_block_public_access_exclusion.avbpae](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_block_public_access_exclusion) | resource |
| [aws_vpc_block_public_access_options.avbpao](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_block_public_access_options) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | (Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false. | `bool` | `false` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | (Required) The CIDR block for the VPC. | `string` | `"0.0.0.0/0"` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | (Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false. | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | (Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults false. | `bool` | `false` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | (Optional) A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host. Using either of the other options (dedicated or host) costs at least $2/hr. | `string` | `"default"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of VPC. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_block_public_access_exclusion_enabled"></a> [vpc\_block\_public\_access\_exclusion\_enabled](#input\_vpc\_block\_public\_access\_exclusion\_enabled) | Whether to create a VPC Block Public Access exclusion for this VPC. | `bool` | `true` | no |
| <a name="input_vpc_block_public_access_exclusion_mode"></a> [vpc\_block\_public\_access\_exclusion\_mode](#input\_vpc\_block\_public\_access\_exclusion\_mode) | Exclusion mode for VPC Block Public Access. Allowed values: allow-egress, allow-bidirectional. | `string` | `"allow-egress"` | no |
| <a name="input_vpc_block_public_access_internet_gateway_block_mode"></a> [vpc\_block\_public\_access\_internet\_gateway\_block\_mode](#input\_vpc\_block\_public\_access\_internet\_gateway\_block\_mode) | Block mode for VPC Block Public Access. Allowed values: block-bidirectional, block-ingress, off. | `string` | `"block-ingress"` | no |
| <a name="input_vpc_block_public_access_manage"></a> [vpc\_block\_public\_access\_manage](#input\_vpc\_block\_public\_access\_manage) | Whether to manage VPC Block Public Access options at the account and region level. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of VPC |
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the route table created by default on VPC creation |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_enable_dns_support"></a> [enable\_dns\_support](#output\_enable\_dns\_support) | Whether or not the VPC has DNS support |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC |
| <a name="output_instance_tenancy"></a> [instance\_tenancy](#output\_instance\_tenancy) | Tenancy of instances spin up within VPC. |
<!-- END_TF_DOCS -->
