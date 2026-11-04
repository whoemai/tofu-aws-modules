output "name" {
  description = "Nome do secret criado"
  value       = aws_secretsmanager_secret.this.name
}

output "arn" {
  description = <<-EOT
    ARN do secret. O sufixo aleatório é gerado pela AWS e é DIFERENTE do de prod — é
    exatamente por isso que os ExternalSecret devem referenciar nome, não ARN.
    Este output serve pras policies IRSA (iam/irsa-app), não pros manifests.
  EOT
  value       = aws_secretsmanager_secret.this.arn
}
