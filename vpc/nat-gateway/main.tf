resource "aws_nat_gateway" "gw" {
  allocation_id                      = var.allocation_id
  availability_mode                  = var.availability_mode
  connectivity_type                  = var.connectivity_type
  private_ip                         = var.private_ip
  subnet_id                          = var.subnet_id
  vpc_id                             = var.vpc_id
  secondary_allocation_ids           = var.secondary_allocation_ids
  secondary_private_ip_addresses     = var.secondary_private_ip_addresses
  secondary_private_ip_address_count = var.secondary_private_ip_address_count
  tags                               = var.tags

  dynamic "availability_zone_address" {
    for_each = var.availability_zone_address
    content {
      allocation_ids       = availability_zone_address.value.allocation_ids
      availability_zone    = try(availability_zone_address.value.availability_zone, null)
      availability_zone_id = try(availability_zone_address.value.availability_zone_id, null)
    }
  }
}
