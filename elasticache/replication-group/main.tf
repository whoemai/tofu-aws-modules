resource "aws_elasticache_replication_group" "this" {
  replication_group_id = var.replication_group_id
  description          = var.description

  engine         = var.engine
  engine_version = var.engine_version
  node_type      = var.node_type
  port           = var.port

  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled

  subnet_group_name    = var.subnet_group_name
  security_group_ids   = var.security_group_ids
  parameter_group_name = var.parameter_group_name

  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.auth_token

  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  # CMK própria em vez da `aws/elasticache`: a chave gerenciada não tem key policy editável, então
  # "quem decifra o cache" é indistinguível de "quem usa ElastiCache na conta". `null` cai nela.
  # ⚠️ Trocar este valor num grupo existente FORÇA REPLACE.
  kms_key_id = var.kms_key_id

  snapshot_retention_limit   = var.snapshot_retention_limit
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  tags = merge(var.tags, { Name = var.replication_group_id })

  # A AWS recusa `auth_token` sem TLS (`InvalidParameterCombination`) — o erro só aparece no
  # apply. `precondition` (e não `validation` cruzada entre variáveis, que exige Terraform 1.9)
  # antecipa pro plan.
  lifecycle {
    precondition {
      condition     = var.auth_token == null || var.transit_encryption_enabled
      error_message = "auth_token exige transit_encryption_enabled = true — a AWS rejeita a combinação."
    }
  }
}
