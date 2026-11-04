locals {
  effective_map_customer_owned_ip_on_launch = var.customer_owned_ipv4_pool != null && var.outpost_arn != null ? var.map_customer_owned_ip_on_launch : null
}

resource "aws_subnet" "subnet" {
  vpc_id                                         = var.vpc_id
  cidr_block                                     = var.cidr_block
  availability_zone                              = var.availability_zone
  availability_zone_id                           = var.availability_zone_id
  map_public_ip_on_launch                        = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation                = var.assign_ipv6_address_on_creation
  ipv6_cidr_block                                = var.ipv6_cidr_block
  ipv6_native                                    = var.ipv6_native
  enable_dns64                                   = var.enable_dns64
  enable_resource_name_dns_a_record_on_launch    = var.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch
  private_dns_hostname_type_on_launch            = var.private_dns_hostname_type_on_launch
  ipv4_ipam_pool_id                              = var.ipv4_ipam_pool_id
  ipv4_netmask_length                            = var.ipv4_netmask_length
  ipv6_ipam_pool_id                              = var.ipv6_ipam_pool_id
  ipv6_netmask_length                            = var.ipv6_netmask_length
  outpost_arn                                    = var.outpost_arn
  customer_owned_ipv4_pool                       = var.customer_owned_ipv4_pool
  map_customer_owned_ip_on_launch                = local.effective_map_customer_owned_ip_on_launch
  enable_lni_at_device_index                     = var.enable_lni_at_device_index

  tags = var.tags
}