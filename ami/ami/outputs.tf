output "id" {
  description = "ID of the created AMI."
  value       = aws_ami.ami.id
}

output "arn" {
  description = "ARN of the AMI."
  value       = aws_ami.ami.arn
}

output "name" {
  description = "Region-unique name for the AMI."
  value       = aws_ami.ami.name
}

output "description" {
  description = "Longer, human-readable description for the AMI."
  value       = aws_ami.ami.description
}

output "architecture" {
  description = "Machine architecture of the AMI."
  value       = aws_ami.ami.architecture
}

output "image_location" {
  description = "Location of the AMI image."
  value       = aws_ami.ami.image_location
}

output "owner_id" {
  description = "AWS account ID of the image owner."
  value       = aws_ami.ami.owner_id
}

output "root_snapshot_id" {
  description = "Snapshot ID for the root volume (for EBS-backed AMIs)."
  value       = aws_ami.ami.root_snapshot_id
}

output "usage_operation" {
  description = "Operation of the Amazon EC2 instance and the billing code that is associated with the AMI."
  value       = aws_ami.ami.usage_operation
}

output "platform_details" {
  description = "Platform details associated with the billing code of the AMI."
  value       = aws_ami.ami.platform_details
}

output "image_owner_alias" {
  description = "AWS account alias (for example, amazon, self) or the AWS account ID of the AMI owner."
  value       = aws_ami.ami.image_owner_alias
}

output "image_type" {
  description = "Type of image."
  value       = aws_ami.ami.image_type
}

output "last_launched_time" {
  description = "Date and time, in ISO 8601 date-time format, when the AMI was last used to launch an EC2 instance. When the AMI is used to launch an instance, there is a 24-hour delay before that usage is reported."
  value       = aws_ami.ami.last_launched_time
}

output "hypervisor" {
  description = "Hypervisor type of the image."
  value       = aws_ami.ami.hypervisor
}

output "platform" {
  description = "This value is set to windows for Windows AMIs; otherwise, it is blank."
  value       = aws_ami.ami.platform
}

output "public" {
  description = "Whether the image has public launch permissions."
  value       = aws_ami.ami.public
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ami.ami.tags_all
}
