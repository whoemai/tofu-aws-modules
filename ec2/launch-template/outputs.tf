output "id" {
  value       = aws_launch_template.this.id
  description = "ID of the launch template."
}

output "arn" {
  value       = aws_launch_template.this.arn
  description = "ARN of the launch template."
}

output "latest_version" {
  value       = aws_launch_template.this.latest_version
  description = "Latest version number of the launch template."
}
