variable "name" {
  type        = string
  description = "(Required) A region-unique name for the AMI."
}

variable "region" {
  type        = string
  default     = null
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "boot_mode" {
  type        = string
  default     = null
  description = "(Optional) Boot mode of the AMI. For more information, see Boot modes in the EC2 User Guide."
}

variable "deprecation_time" {
  type        = string
  default     = null
  description = "(Optional) Date and time to deprecate the AMI. If you specified a value for seconds, Amazon EC2 rounds the seconds to the nearest minute. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)."
}

variable "description" {
  type        = string
  default     = null
  description = "(Optional) Longer, human-readable description for the AMI."
}

variable "ena_support" {
  type        = bool
  default     = null
  description = "(Optional) Whether enhanced networking with ENA is enabled. The provider defaults to false."
}

variable "root_device_name" {
  type        = string
  default     = null
  description = "(Optional) Name of the root device (for example, /dev/sda1, or /dev/xvda)."
}

variable "virtualization_type" {
  type        = string
  default     = null
  description = "(Optional) Keyword to choose what virtualization mode created instances will use. Can be either paravirtual (the provider default) or hvm. The choice of virtualization type changes the set of further arguments that are required."

  validation {
    condition     = var.virtualization_type == null || contains(["paravirtual", "hvm"], var.virtualization_type)
    error_message = "virtualization_type must be paravirtual or hvm."
  }
}

variable "architecture" {
  type        = string
  default     = null
  description = "(Optional) Machine architecture for created instances. The provider defaults to x86_64."
}

variable "tpm_support" {
  type        = string
  default     = null
  description = "(Optional) If the image is configured for NitroTPM support, the value is v2.0. For more information, see NitroTPM in the EC2 User Guide."
}

variable "imds_support" {
  type        = string
  default     = null
  description = "(Optional) If EC2 instances started from this image should require the use of the Instance Metadata Service V2 (IMDSv2), set this argument to v2.0."
}

variable "uefi_data" {
  type        = string
  default     = null
  description = "(Optional) Base64 representation of the non-volatile UEFI variable store."
}

variable "image_location" {
  type        = string
  default     = null
  description = "(Required when virtualization_type is paravirtual) Path to an S3 object containing an image manifest, e.g., created by the ec2-upload-bundle command in the EC2 command line tools."
}

variable "kernel_id" {
  type        = string
  default     = null
  description = "(Required when virtualization_type is paravirtual) ID of the kernel image (AKI) that will be used as the paravirtual kernel in created instances."
}

variable "ramdisk_id" {
  type        = string
  default     = null
  description = "(Optional, when virtualization_type is paravirtual) ID of an initrd image (ARI) that will be used when booting the created instances."
}

variable "sriov_net_support" {
  type        = string
  default     = null
  description = "(Optional, when virtualization_type is hvm) When set to simple (the provider default), enables enhanced networking for created instances. No other value is supported at this time."
}

variable "ebs_block_devices" {
  type = list(object({
    device_name           = string
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    outpost_arn           = optional(string)
    snapshot_id           = optional(string)
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
  }))
  default     = []
  description = <<-EOT
    (Optional) Nested ebs_block_device blocks describing EBS block devices that should be attached to created instances. Each item:
    - device_name           (Required) Path at which the device is exposed to created instances.
    - delete_on_termination (Optional) Boolean controlling whether the EBS volumes created to support each created instance will be deleted once that instance is terminated.
    - encrypted             (Optional) Boolean controlling whether the created EBS volumes will be encrypted. Can't be used with snapshot_id.
    - iops                  (Required only when volume_type is io1 or io2) Number of I/O operations per second the created volumes will support.
    - snapshot_id           (Optional) ID of an EBS snapshot that will be used to initialize the created EBS volumes. If set, the volume_size attribute must be at least as large as the referenced snapshot.
    - throughput            (Optional) Throughput that the EBS volume supports, in MiB/s. Only valid for volume_type of gp3.
    - volume_size           (Required unless snapshot_id is set) Size of created volumes in GiB. If snapshot_id is set and volume_size is omitted then the volume will have the same size as the selected snapshot.
    - volume_type           (Optional) Type of EBS volume to create. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (provider default: standard).
    - outpost_arn           (Optional) ARN of the Outpost on which the snapshot is stored.
    You can specify encrypted or snapshot_id but not both.
  EOT

  validation {
    condition = alltrue([
      for d in var.ebs_block_devices :
      d.volume_type == null || contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], d.volume_type)
    ])
    error_message = "volume_type must be one of: standard, gp2, gp3, io1, io2, sc1, st1."
  }
}

variable "ephemeral_block_devices" {
  type = list(object({
    device_name  = string
    virtual_name = string
  }))
  default     = []
  description = "(Optional) Nested ephemeral_block_device blocks describing ephemeral block devices that should be attached to created instances. device_name (Required) is the path at which the device is exposed to created instances. virtual_name (Required) is the name for the ephemeral device, of the form ephemeralN where N is a volume number starting from zero."
}

variable "timeouts" {
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = "(Optional) Operation timeouts. The provider defaults are create 40m, update 40m and delete 90m."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}
