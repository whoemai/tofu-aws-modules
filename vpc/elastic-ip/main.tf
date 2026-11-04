locals {
  eip_domain = var.domain != null ? var.domain : (var.vpc == null ? "vpc" : (var.vpc ? "vpc" : "standard"))
}

resource "aws_eip" "eip" {
  domain = local.eip_domain
  tags   = var.tags
}
