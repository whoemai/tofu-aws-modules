resource "aws_eks_node_group" "node_group" {
  cluster_name           = var.cluster_name
  node_group_name        = var.node_group_name
  node_group_name_prefix = var.node_group_name_prefix
  node_role_arn          = var.node_role_arn
  subnet_ids             = var.subnet_ids
  ami_type               = var.ami_type
  capacity_type          = var.capacity_type
  disk_size              = var.disk_size
  force_update_version   = var.force_update_version
  instance_types         = var.instance_types
  labels                 = var.labels
  release_version        = var.release_version
  version                = var.kubernetes_version
  tags                   = var.tags

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = try(launch_template.value.id, null)
      name    = try(launch_template.value.name, null)
      version = launch_template.value.version
    }
  }

  dynamic "remote_access" {
    for_each = var.remote_access != null ? [var.remote_access] : []
    content {
      ec2_ssh_key               = try(remote_access.value.ec2_ssh_key, null)
      source_security_group_ids = try(remote_access.value.source_security_group_ids, null)
    }
  }

  dynamic "update_config" {
    for_each = var.update_config != null ? [var.update_config] : []
    content {
      max_unavailable            = try(update_config.value.max_unavailable, null)
      max_unavailable_percentage = try(update_config.value.max_unavailable_percentage, null)
      update_strategy            = try(update_config.value.update_strategy, null)
    }
  }

  dynamic "taint" {
    for_each = var.taints
    content {
      key    = taint.value.key
      value  = try(taint.value.value, null)
      effect = taint.value.effect
    }
  }

  dynamic "node_repair_config" {
    for_each = var.node_repair_config != null ? [var.node_repair_config] : []
    content {
      enabled = try(node_repair_config.value.enabled, null)
    }
  }

  dynamic "warm_pool_config" {
    for_each = var.warm_pool_config != null ? [var.warm_pool_config] : []
    content {
      max_group_prepared_capacity = try(warm_pool_config.value.max_group_prepared_capacity, null)
      min_size                    = try(warm_pool_config.value.min_size, null)
      pool_state                  = try(warm_pool_config.value.pool_state, null)
      reuse_on_scale_in           = try(warm_pool_config.value.reuse_on_scale_in, null)
    }
  }
}
