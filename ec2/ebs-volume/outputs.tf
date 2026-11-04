output "id" {
  description = "ID of the EBS volume"
  value       = aws_ebs_volume.this.id
}

output "arn" {
  description = "ARN of the EBS volume"
  value       = aws_ebs_volume.this.arn
}
