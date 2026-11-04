# Only created when var.cluster_parameters is non-empty; otherwise the cluster
# uses the AWS default group for its family (default.docdb5.0 etc.).
resource "aws_docdb_cluster_parameter_group" "this" {
  count = length(var.cluster_parameters) > 0 ? 1 : 0

  name   = var.cluster_identifier
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = var.tags

  # A parameter group in use can't be deleted — a family bump has to create the
  # new one first.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier = var.cluster_identifier
  engine_version     = var.engine_version
  port               = var.port

  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name            = var.db_subnet_group_name
  vpc_security_group_ids          = var.vpc_security_group_ids
  db_cluster_parameter_group_name = length(var.cluster_parameters) > 0 ? aws_docdb_cluster_parameter_group.this[0].name : null

  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  storage_type      = var.storage_type

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.cluster_identifier}-final"
  apply_immediately         = var.apply_immediately

  tags = var.tags
}

# Instances named <cluster_identifier>-<n>. The first one created becomes the
# writer; lowering var.instance_count destroys the highest-numbered ones and
# DocumentDB promotes a replica if the writer goes.
resource "aws_docdb_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class

  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  preferred_maintenance_window = var.preferred_maintenance_window
  promotion_tier               = var.promotion_tier
  ca_cert_identifier           = var.ca_cert_identifier
  apply_immediately            = var.apply_immediately

  tags = var.tags
}
