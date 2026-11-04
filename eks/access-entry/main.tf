resource "aws_eks_access_entry" "access_entry" {
  cluster_name      = var.cluster_name
  principal_arn     = var.principal_arn
  kubernetes_groups = var.kubernetes_groups
  type              = var.type
  user_name         = var.user_name
  tags              = var.tags
}
