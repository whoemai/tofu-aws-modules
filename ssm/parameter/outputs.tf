output "name" {
  description = "Path do parametro criado"
  value       = aws_ssm_parameter.this.name
}

output "arn" {
  description = "ARN do parametro — input das policies IRSA (iam/irsa-app)"
  value       = aws_ssm_parameter.this.arn
}
