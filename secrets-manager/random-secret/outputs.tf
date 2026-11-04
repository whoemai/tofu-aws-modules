output "name" {
  description = "Nome do secret criado"
  value       = aws_secretsmanager_secret.this.name
}

output "arn" {
  description = "ARN do secret"
  value       = aws_secretsmanager_secret.this.arn
}

output "password" {
  description = "Senha gerada, em texto puro. Sensível — não logar."
  value       = random_password.this.result
  sensitive   = true
}
