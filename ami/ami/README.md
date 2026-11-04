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
| [aws_ami.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | (Optional) Machine architecture for created instances. The provider defaults to x86\_64. | `string` | `null` | no |
| <a name="input_boot_mode"></a> [boot\_mode](#input\_boot\_mode) | (Optional) Boot mode of the AMI. For more information, see Boot modes in the EC2 User Guide. | `string` | `null` | no |
| <a name="input_deprecation_time"></a> [deprecation\_time](#input\_deprecation\_time) | (Optional) Date and time to deprecate the AMI. If you specified a value for seconds, Amazon EC2 rounds the seconds to the nearest minute. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ). | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Longer, human-readable description for the AMI. | `string` | `null` | no |
| <a name="input_ebs_block_devices"></a> [ebs\_block\_devices](#input\_ebs\_block\_devices) | (Optional) Nested ebs\_block\_device blocks describing EBS block devices that should be attached to created instances. Each item:<br>- device\_name           (Required) Path at which the device is exposed to created instances.<br>- delete\_on\_termination (Optional) Boolean controlling whether the EBS volumes created to support each created instance will be deleted once that instance is terminated.<br>- encrypted             (Optional) Boolean controlling whether the created EBS volumes will be encrypted. Can't be used with snapshot\_id.<br>- iops                  (Required only when volume\_type is io1 or io2) Number of I/O operations per second the created volumes will support.<br>- snapshot\_id           (Optional) ID of an EBS snapshot that will be used to initialize the created EBS volumes. If set, the volume\_size attribute must be at least as large as the referenced snapshot.<br>- throughput            (Optional) Throughput that the EBS volume supports, in MiB/s. Only valid for volume\_type of gp3.<br>- volume\_size           (Required unless snapshot\_id is set) Size of created volumes in GiB. If snapshot\_id is set and volume\_size is omitted then the volume will have the same size as the selected snapshot.<br>- volume\_type           (Optional) Type of EBS volume to create. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (provider default: standard).<br>- outpost\_arn           (Optional) ARN of the Outpost on which the snapshot is stored.<br>You can specify encrypted or snapshot\_id but not both. | <pre>list(object({<br>    device_name           = string<br>    delete_on_termination = optional(bool)<br>    encrypted             = optional(bool)<br>    iops                  = optional(number)<br>    outpost_arn           = optional(string)<br>    snapshot_id           = optional(string)<br>    throughput            = optional(number)<br>    volume_size           = optional(number)<br>    volume_type           = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_ena_support"></a> [ena\_support](#input\_ena\_support) | (Optional) Whether enhanced networking with ENA is enabled. The provider defaults to false. | `bool` | `null` | no |
| <a name="input_ephemeral_block_devices"></a> [ephemeral\_block\_devices](#input\_ephemeral\_block\_devices) | (Optional) Nested ephemeral\_block\_device blocks describing ephemeral block devices that should be attached to created instances. device\_name (Required) is the path at which the device is exposed to created instances. virtual\_name (Required) is the name for the ephemeral device, of the form ephemeralN where N is a volume number starting from zero. | <pre>list(object({<br>    device_name  = string<br>    virtual_name = string<br>  }))</pre> | `[]` | no |
| <a name="input_image_location"></a> [image\_location](#input\_image\_location) | (Required when virtualization\_type is paravirtual) Path to an S3 object containing an image manifest, e.g., created by the ec2-upload-bundle command in the EC2 command line tools. | `string` | `null` | no |
| <a name="input_imds_support"></a> [imds\_support](#input\_imds\_support) | (Optional) If EC2 instances started from this image should require the use of the Instance Metadata Service V2 (IMDSv2), set this argument to v2.0. | `string` | `null` | no |
| <a name="input_kernel_id"></a> [kernel\_id](#input\_kernel\_id) | (Required when virtualization\_type is paravirtual) ID of the kernel image (AKI) that will be used as the paravirtual kernel in created instances. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) A region-unique name for the AMI. | `string` | n/a | yes |
| <a name="input_ramdisk_id"></a> [ramdisk\_id](#input\_ramdisk\_id) | (Optional, when virtualization\_type is paravirtual) ID of an initrd image (ARI) that will be used when booting the created instances. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration. | `string` | `null` | no |
| <a name="input_root_device_name"></a> [root\_device\_name](#input\_root\_device\_name) | (Optional) Name of the root device (for example, /dev/sda1, or /dev/xvda). | `string` | `null` | no |
| <a name="input_sriov_net_support"></a> [sriov\_net\_support](#input\_sriov\_net\_support) | (Optional, when virtualization\_type is hvm) When set to simple (the provider default), enables enhanced networking for created instances. No other value is supported at this time. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) Operation timeouts. The provider defaults are create 40m, update 40m and delete 90m. | <pre>object({<br>    create = optional(string)<br>    update = optional(string)<br>    delete = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_tpm_support"></a> [tpm\_support](#input\_tpm\_support) | (Optional) If the image is configured for NitroTPM support, the value is v2.0. For more information, see NitroTPM in the EC2 User Guide. | `string` | `null` | no |
| <a name="input_uefi_data"></a> [uefi\_data](#input\_uefi\_data) | (Optional) Base64 representation of the non-volatile UEFI variable store. | `string` | `null` | no |
| <a name="input_virtualization_type"></a> [virtualization\_type](#input\_virtualization\_type) | (Optional) Keyword to choose what virtualization mode created instances will use. Can be either paravirtual (the provider default) or hvm. The choice of virtualization type changes the set of further arguments that are required. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_architecture"></a> [architecture](#output\_architecture) | Machine architecture of the AMI. |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the AMI. |
| <a name="output_description"></a> [description](#output\_description) | Longer, human-readable description for the AMI. |
| <a name="output_hypervisor"></a> [hypervisor](#output\_hypervisor) | Hypervisor type of the image. |
| <a name="output_id"></a> [id](#output\_id) | ID of the created AMI. |
| <a name="output_image_location"></a> [image\_location](#output\_image\_location) | Location of the AMI image. |
| <a name="output_image_owner_alias"></a> [image\_owner\_alias](#output\_image\_owner\_alias) | AWS account alias (for example, amazon, self) or the AWS account ID of the AMI owner. |
| <a name="output_image_type"></a> [image\_type](#output\_image\_type) | Type of image. |
| <a name="output_last_launched_time"></a> [last\_launched\_time](#output\_last\_launched\_time) | Date and time, in ISO 8601 date-time format, when the AMI was last used to launch an EC2 instance. When the AMI is used to launch an instance, there is a 24-hour delay before that usage is reported. |
| <a name="output_name"></a> [name](#output\_name) | Region-unique name for the AMI. |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | AWS account ID of the image owner. |
| <a name="output_platform"></a> [platform](#output\_platform) | This value is set to windows for Windows AMIs; otherwise, it is blank. |
| <a name="output_platform_details"></a> [platform\_details](#output\_platform\_details) | Platform details associated with the billing code of the AMI. |
| <a name="output_public"></a> [public](#output\_public) | Whether the image has public launch permissions. |
| <a name="output_root_snapshot_id"></a> [root\_snapshot\_id](#output\_root\_snapshot\_id) | Snapshot ID for the root volume (for EBS-backed AMIs). |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_usage_operation"></a> [usage\_operation](#output\_usage\_operation) | Operation of the Amazon EC2 instance and the billing code that is associated with the AMI. |
<!-- END_TF_DOCS -->
