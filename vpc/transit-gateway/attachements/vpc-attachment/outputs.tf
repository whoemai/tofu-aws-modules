output "id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.id
  description = "Transit Gateway VPC attachment ID."
}

output "arn" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.arn
  description = "Transit Gateway VPC attachment ARN."
}

output "transit_gateway_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.transit_gateway_id
  description = "Transit Gateway ID."
}

output "vpc_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.vpc_id
  description = "VPC ID."
}

output "subnet_ids" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.subnet_ids
  description = "Subnet IDs used by the attachment."
}

output "tags_all" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.tags_all
  description = "All tags, including provider defaults."
}

output "vpc_owner_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attachment.vpc_owner_id
  description = "AWS account ID that owns the VPC."
}
