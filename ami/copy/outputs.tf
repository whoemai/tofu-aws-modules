output "id" {
  description = "ID of the created AMI."
  value       = aws_ami_copy.this.id
}

output "arn" {
  description = "ARN of the AMI."
  value       = aws_ami_copy.this.arn
}

output "name" {
  description = "Region-unique name for the AMI."
  value       = aws_ami_copy.this.name
}

output "description" {
  description = "Longer, human-readable description for the AMI."
  value       = aws_ami_copy.this.description
}

output "architecture" {
  description = "Machine architecture of the AMI."
  value       = aws_ami_copy.this.architecture
}

output "image_location" {
  description = "Location of the AMI image."
  value       = aws_ami_copy.this.image_location
}

output "owner_id" {
  description = "AWS account ID of the image owner."
  value       = aws_ami_copy.this.owner_id
}

output "root_snapshot_id" {
  description = "Snapshot ID for the root volume (for EBS-backed AMIs)."
  value       = aws_ami_copy.this.root_snapshot_id
}

output "usage_operation" {
  description = "Operation of the Amazon EC2 instance and the billing code that is associated with the AMI."
  value       = aws_ami_copy.this.usage_operation
}

output "platform_details" {
  description = "Platform details associated with the billing code of the AMI."
  value       = aws_ami_copy.this.platform_details
}

output "image_owner_alias" {
  description = "AWS account alias (for example, amazon, self) or the AWS account ID of the AMI owner."
  value       = aws_ami_copy.this.image_owner_alias
}

output "image_type" {
  description = "Type of image."
  value       = aws_ami_copy.this.image_type
}

output "last_launched_time" {
  description = "Date and time, in ISO 8601 date-time format, when the AMI was last used to launch an EC2 instance. When the AMI is used to launch an instance, there is a 24-hour delay before that usage is reported."
  value       = aws_ami_copy.this.last_launched_time
}

output "hypervisor" {
  description = "Hypervisor type of the image."
  value       = aws_ami_copy.this.hypervisor
}

output "platform" {
  description = "This value is set to windows for Windows AMIs; otherwise, it is blank."
  value       = aws_ami_copy.this.platform
}

output "public" {
  description = "Whether the image has public launch permissions."
  value       = aws_ami_copy.this.public
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ami_copy.this.tags_all
}

output "kms_key_id" {
  description = "Full ARN of the KMS Key used when encrypting the snapshots of the image during the copy operation."
  value       = aws_ami_copy.this.kms_key_id
}

output "boot_mode" {
  description = "Boot mode of the AMI."
  value       = aws_ami_copy.this.boot_mode
}

output "ena_support" {
  description = "Whether enhanced networking with ENA is enabled."
  value       = aws_ami_copy.this.ena_support
}

output "imds_support" {
  description = "Whether EC2 instances started from this image require the use of the Instance Metadata Service V2 (IMDSv2), when set to v2.0."
  value       = aws_ami_copy.this.imds_support
}

output "kernel_id" {
  description = "ID of the kernel image (AKI) that is used as the paravirtual kernel in created instances."
  value       = aws_ami_copy.this.kernel_id
}

output "ramdisk_id" {
  description = "ID of an initrd image (ARI) that is used when booting the created instances."
  value       = aws_ami_copy.this.ramdisk_id
}

output "root_device_name" {
  description = "Name of the root device (for example, /dev/sda1, or /dev/xvda)."
  value       = aws_ami_copy.this.root_device_name
}

output "sriov_net_support" {
  description = "Whether enhanced networking is enabled for created instances (simple)."
  value       = aws_ami_copy.this.sriov_net_support
}

output "tpm_support" {
  description = "If the image is configured for NitroTPM support, the value is v2.0."
  value       = aws_ami_copy.this.tpm_support
}

output "uefi_data" {
  description = "Base64 representation of the non-volatile UEFI variable store."
  value       = aws_ami_copy.this.uefi_data
}

output "virtualization_type" {
  description = "Virtualization mode that created instances use: paravirtual or hvm."
  value       = aws_ami_copy.this.virtualization_type
}

output "deprecation_time" {
  description = "Date and time to deprecate the AMI (RFC3339)."
  value       = aws_ami_copy.this.deprecation_time
}
