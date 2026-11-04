resource "aws_eks_cluster" "cluster" {
  name                          = var.name
  role_arn                      = var.role_arn
  version                       = var.kubernetes_version
  bootstrap_self_managed_addons = var.bootstrap_self_managed_addons
  deletion_protection           = var.deletion_protection
  enabled_cluster_log_types     = var.enabled_cluster_log_types
  force_update_version          = var.force_update_version
  tags                          = var.tags

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = var.security_group_ids
  }

  dynamic "access_config" {
    for_each = var.access_config != null ? [var.access_config] : []
    content {
      authentication_mode                         = try(access_config.value.authentication_mode, null)
      bootstrap_cluster_creator_admin_permissions = try(access_config.value.bootstrap_cluster_creator_admin_permissions, null)
    }
  }

  dynamic "encryption_config" {
    for_each = var.encryption_config != null ? [var.encryption_config] : []
    content {
      resources = encryption_config.value.resources

      provider {
        key_arn = encryption_config.value.provider_key_arn
      }
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = var.kubernetes_network_config != null ? [var.kubernetes_network_config] : []
    content {
      service_ipv4_cidr = try(kubernetes_network_config.value.service_ipv4_cidr, null)
      ip_family         = try(kubernetes_network_config.value.ip_family, null)

      dynamic "elastic_load_balancing" {
        for_each = try(kubernetes_network_config.value.elastic_load_balancing_enabled, null) != null ? [1] : []
        content {
          enabled = kubernetes_network_config.value.elastic_load_balancing_enabled
        }
      }
    }
  }

  dynamic "compute_config" {
    for_each = var.compute_config != null ? [var.compute_config] : []
    content {
      enabled       = try(compute_config.value.enabled, null)
      node_pools    = try(compute_config.value.node_pools, null)
      node_role_arn = try(compute_config.value.node_role_arn, null)
    }
  }

  dynamic "storage_config" {
    for_each = var.storage_config_block_storage_enabled != null ? [1] : []
    content {
      block_storage {
        enabled = var.storage_config_block_storage_enabled
      }
    }
  }

  dynamic "outpost_config" {
    for_each = var.outpost_config != null ? [var.outpost_config] : []
    content {
      control_plane_instance_type = outpost_config.value.control_plane_instance_type
      outpost_arns                = outpost_config.value.outpost_arns
    }
  }

  dynamic "upgrade_policy" {
    for_each = var.upgrade_policy_support_type != null ? [var.upgrade_policy_support_type] : []
    content {
      support_type = upgrade_policy.value
    }
  }

  dynamic "zonal_shift_config" {
    for_each = var.zonal_shift_config_enabled != null ? [var.zonal_shift_config_enabled] : []
    content {
      enabled = zonal_shift_config.value
    }
  }
}
