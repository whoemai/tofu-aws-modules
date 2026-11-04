locals {
  is_postgres   = startswith(var.engine, "postgres")
  port          = local.is_postgres ? 5432 : 3306
  major_version = local.is_postgres ? split(".", var.engine_version)[0] : join(".", slice(split(".", var.engine_version), 0, 2))
  family        = coalesce(var.parameter_group_family, "${var.engine}${local.major_version}")
}

resource "random_password" "master" {
  length           = 32
  override_special = "!#$*-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "master" {
  name                    = var.master_secret_name
  description             = "Credencial master do RDS ${var.identifier} (gerada pelo Terraform)"
  recovery_window_in_days = 0 # ver secrets-manager/secrets: janela quebra o recreate
  kms_key_id              = var.kms_key_id
  tags                    = merge(var.tags, { Name = var.master_secret_name })
}

resource "aws_secretsmanager_secret_version" "master" {
  secret_id = aws_secretsmanager_secret.master.id
  secret_string = jsonencode({
    engine   = var.engine
    username = var.master_username
    password = random_password.master.result
    host     = aws_db_instance.this.address
    port     = local.port
    dbname   = var.database_name
    cname    = var.dns_cname
  })
}

resource "aws_db_subnet_group" "this" {
  name       = var.identifier
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = var.identifier })
}

resource "aws_security_group" "this" {
  name_prefix = "${var.identifier}-rds-"
  description = "Acesso ao RDS ${var.identifier} a partir dos nos do EKS"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.identifier}-rds" })
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_nodes" {
  for_each                     = toset(var.allowed_security_group_ids)
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = each.value
  from_port                    = local.port
  to_port                      = local.port
  ip_protocol                  = "tcp"
  description                  = "Porta ${local.port} a partir do SG ${each.value}"
}

resource "aws_vpc_security_group_ingress_rule" "from_cidrs" {
  for_each          = toset(var.allowed_cidr_blocks)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  from_port         = local.port
  to_port           = local.port
  ip_protocol       = "tcp"
  description       = "Porta ${local.port} a partir de ${each.value}"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound"
}

resource "aws_db_parameter_group" "this" {
  name_prefix = "${var.identifier}-"
  family      = local.family
  description = "Parameter group do ${var.identifier}"
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
  tags = merge(var.tags, { Name = var.identifier })
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "rds" {
  for_each          = toset(var.enabled_cloudwatch_logs_exports)
  name              = "/aws/rds/instance/${var.identifier}/${each.value}"
  retention_in_days = var.cloudwatch_logs_retention_days
  tags              = merge(var.tags, { Name = "${var.identifier}-${each.value}" })
}

resource "aws_db_instance" "this" {
  identifier                          = var.identifier
  depends_on                          = [aws_cloudwatch_log_group.rds]
  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  max_allocated_storage               = var.max_allocated_storage
  storage_type                        = var.storage_type
  storage_encrypted                   = var.storage_encrypted
  kms_key_id                          = var.kms_key_id
  db_name                             = var.database_name
  username                            = var.master_username
  password                            = random_password.master.result
  port                                = local.port
  db_subnet_group_name                = aws_db_subnet_group.this.name
  vpc_security_group_ids              = [aws_security_group.this.id]
  parameter_group_name                = aws_db_parameter_group.this.name
  publicly_accessible                 = var.publicly_accessible
  multi_az                            = var.multi_az
  backup_retention_period             = var.backup_retention_period
  skip_final_snapshot                 = var.skip_final_snapshot
  deletion_protection                 = var.deletion_protection
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  performance_insights_enabled        = var.performance_insights_enabled
  monitoring_interval                 = var.monitoring_interval
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  apply_immediately                   = var.apply_immediately
  tags                                = merge(var.tags, { Name = var.identifier })
}
