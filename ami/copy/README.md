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
| [aws_ami_copy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_copy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deprecation_time"></a> [deprecation\_time](#input\_deprecation\_time) | (Optional) Date and time to deprecate the AMI. If you specified a value for seconds, Amazon EC2 rounds the seconds to the nearest minute. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ). | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Longer, human-readable description for the AMI. | `string` | `null` | no |
| <a name="input_destination_outpost_arn"></a> [destination\_outpost\_arn](#input\_destination\_outpost\_arn) | (Optional) ARN of the Outpost to which to copy the AMI. Only specify this parameter when copying an AMI from an AWS Region to an Outpost. The AMI must be in the Region of the destination Outpost. | `string` | `null` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | (Optional) Whether the destination snapshots of the copied image should be encrypted. The provider defaults to false. | `bool` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | (Optional) Full ARN of the KMS Key to use when encrypting the snapshots of an image during a copy operation. If not specified, then the default AWS KMS Key will be used. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) A region-unique name for the copied AMI. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | (Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration. | `string` | `null` | no |
| <a name="input_source_ami_id"></a> [source\_ami\_id](#input\_source\_ami\_id) | (Required) ID of the AMI to copy. This ID must be valid in the region given by source\_ami\_region. Must be shared (launch permission) with this account first if it lives in another account. That share is not managed by this module. | `string` | n/a | yes |
| <a name="input_source_ami_region"></a> [source\_ami\_region](#input\_source\_ami\_region) | (Required) Region from which the AMI will be copied. This may be the same as the AWS provider region in order to create a copy within the same region. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) Operation timeouts. The provider defaults are create 40m, update 40m and delete 90m. | <pre>object({<br>    create = optional(string)<br>    update = optional(string)<br>    delete = optional(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_architecture"></a> [architecture](#output\_architecture) | Machine architecture of the AMI. |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the AMI. |
| <a name="output_boot_mode"></a> [boot\_mode](#output\_boot\_mode) | Boot mode of the AMI. |
| <a name="output_deprecation_time"></a> [deprecation\_time](#output\_deprecation\_time) | Date and time to deprecate the AMI (RFC3339). |
| <a name="output_description"></a> [description](#output\_description) | Longer, human-readable description for the AMI. |
| <a name="output_ena_support"></a> [ena\_support](#output\_ena\_support) | Whether enhanced networking with ENA is enabled. |
| <a name="output_hypervisor"></a> [hypervisor](#output\_hypervisor) | Hypervisor type of the image. |
| <a name="output_id"></a> [id](#output\_id) | ID of the created AMI. |
| <a name="output_image_location"></a> [image\_location](#output\_image\_location) | Location of the AMI image. |
| <a name="output_image_owner_alias"></a> [image\_owner\_alias](#output\_image\_owner\_alias) | AWS account alias (for example, amazon, self) or the AWS account ID of the AMI owner. |
| <a name="output_image_type"></a> [image\_type](#output\_image\_type) | Type of image. |
| <a name="output_imds_support"></a> [imds\_support](#output\_imds\_support) | Whether EC2 instances started from this image require the use of the Instance Metadata Service V2 (IMDSv2), when set to v2.0. |
| <a name="output_kernel_id"></a> [kernel\_id](#output\_kernel\_id) | ID of the kernel image (AKI) that is used as the paravirtual kernel in created instances. |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | Full ARN of the KMS Key used when encrypting the snapshots of the image during the copy operation. |
| <a name="output_last_launched_time"></a> [last\_launched\_time](#output\_last\_launched\_time) | Date and time, in ISO 8601 date-time format, when the AMI was last used to launch an EC2 instance. When the AMI is used to launch an instance, there is a 24-hour delay before that usage is reported. |
| <a name="output_name"></a> [name](#output\_name) | Region-unique name for the AMI. |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | AWS account ID of the image owner. |
| <a name="output_platform"></a> [platform](#output\_platform) | This value is set to windows for Windows AMIs; otherwise, it is blank. |
| <a name="output_platform_details"></a> [platform\_details](#output\_platform\_details) | Platform details associated with the billing code of the AMI. |
| <a name="output_public"></a> [public](#output\_public) | Whether the image has public launch permissions. |
| <a name="output_ramdisk_id"></a> [ramdisk\_id](#output\_ramdisk\_id) | ID of an initrd image (ARI) that is used when booting the created instances. |
| <a name="output_root_device_name"></a> [root\_device\_name](#output\_root\_device\_name) | Name of the root device (for example, /dev/sda1, or /dev/xvda). |
| <a name="output_root_snapshot_id"></a> [root\_snapshot\_id](#output\_root\_snapshot\_id) | Snapshot ID for the root volume (for EBS-backed AMIs). |
| <a name="output_sriov_net_support"></a> [sriov\_net\_support](#output\_sriov\_net\_support) | Whether enhanced networking is enabled for created instances (simple). |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_tpm_support"></a> [tpm\_support](#output\_tpm\_support) | If the image is configured for NitroTPM support, the value is v2.0. |
| <a name="output_uefi_data"></a> [uefi\_data](#output\_uefi\_data) | Base64 representation of the non-volatile UEFI variable store. |
| <a name="output_usage_operation"></a> [usage\_operation](#output\_usage\_operation) | Operation of the Amazon EC2 instance and the billing code that is associated with the AMI. |
| <a name="output_virtualization_type"></a> [virtualization\_type](#output\_virtualization\_type) | Virtualization mode that created instances use: paravirtual or hvm. |
<!-- END_TF_DOCS -->
