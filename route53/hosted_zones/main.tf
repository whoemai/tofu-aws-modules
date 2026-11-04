resource "aws_route53_zone" "zone" {
  name              = var.name
  comment           = var.comment
  tags              = var.tags
  delegation_set_id = var.delegation_set_id
  force_destroy     = var.force_destroy

  dynamic "vpc" {
    for_each = var.vpcs
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region
    }
  }
}