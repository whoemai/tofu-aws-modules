output "id" {
  description = "ID do grupo — é o que o `terraform import` pede."
  value       = aws_elasticache_replication_group.this.id
}

output "arn" {
  description = "ARN do replication group."
  value       = aws_elasticache_replication_group.this.arn
}

output "primary_endpoint_address" {
  description = "Endpoint primário (leitura e escrita) — é o host que a aplicação usa."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Endpoint de leitura. Com um nó só, aponta pro mesmo lugar do primário."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "port" {
  description = "Porta da engine."
  value       = aws_elasticache_replication_group.this.port
}

output "transit_encryption_enabled" {
  description = "Se o cliente precisa falar TLS — evita que quem monta o overlay adivinhe."
  value       = aws_elasticache_replication_group.this.transit_encryption_enabled
}

output "member_clusters" {
  description = "Nós do grupo. É por aqui que se confere se o failover tem réplica pra onde ir."
  value       = aws_elasticache_replication_group.this.member_clusters
}
