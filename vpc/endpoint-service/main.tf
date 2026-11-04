resource "aws_vpc_endpoint_service" "endpoint_service" {
  acceptance_required        = var.acceptance_required
  network_load_balancer_arns = var.network_load_balancer_arns
  allowed_principals         = var.allowed_principals

  private_dns_name  = var.private_dns_name
  supported_regions = var.supported_regions

  tags = var.tags
}