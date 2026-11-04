output "identifier" {
  description = "Identifier da instância RDS."
  value       = aws_db_instance.this.identifier
}

output "address" {
  description = "Hostname do endpoint (sem porta) — alvo do CNAME em route53/records"
  value       = aws_db_instance.this.address
}

output "endpoint" {
  description = "Endpoint completo host:porta"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "Porta do banco — usada por unit que monta connection string ou SG rule."
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "SG do banco — útil pra liberar outra origem sem mexer no módulo"
  value       = aws_security_group.this.id
}

output "master_secret_arn" {
  description = "ARN do secret com a credencial master — input da policy do job de seed"
  value       = aws_secretsmanager_secret.master.arn
}

output "master_secret_name" {
  description = "Nome do secret master — é o que o ExternalSecret/seed referencia (nome, nunca ARN)"
  value       = aws_secretsmanager_secret.master.name
}
