resource "aws_vpc" "vpc" {

  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  # enable_classiclink                = var.enable_classiclink
  #enable_classiclink_dns_support    = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = var.tags

}

resource "aws_vpc_block_public_access_options" "avbpao" {
  count = var.vpc_block_public_access_manage ? 1 : 0

  internet_gateway_block_mode = var.vpc_block_public_access_internet_gateway_block_mode
}

resource "aws_vpc_block_public_access_exclusion" "avbpae" {
  count = var.vpc_block_public_access_exclusion_enabled ? 1 : 0

  vpc_id                          = aws_vpc.vpc.id
  internet_gateway_exclusion_mode = var.vpc_block_public_access_exclusion_mode
}