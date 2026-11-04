resource "aws_eks_addon" "addon" {
  cluster_name                = var.cluster_name
  addon_name                  = var.addon_name
  addon_version               = var.addon_version
  configuration_values        = var.configuration_values
  preserve                    = var.preserve
  resolve_conflicts_on_create = var.resolve_conflicts_on_create
  resolve_conflicts_on_update = var.resolve_conflicts_on_update
  service_account_role_arn    = var.service_account_role_arn
  tags                        = var.tags

  dynamic "namespace_config" {
    for_each = var.namespace != null ? [var.namespace] : []
    content {
      namespace = namespace_config.value
    }
  }

  dynamic "pod_identity_association" {
    for_each = var.pod_identity_associations
    content {
      role_arn        = pod_identity_association.value.role_arn
      service_account = pod_identity_association.value.service_account
    }
  }
}
