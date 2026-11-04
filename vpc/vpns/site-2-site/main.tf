locals {
  use_transit_gateway = var.transit_gateway_id != null && var.transit_gateway_id != ""

  customer_gateway_id = var.customer_gateway_id != null && var.customer_gateway_id != "" ? var.customer_gateway_id : aws_customer_gateway.this[0].id
  vpn_gateway_id      = var.create_vpn_gateway ? aws_vpn_gateway.this[0].id : var.vpn_gateway_id
}

resource "aws_customer_gateway" "this" {
  count = var.customer_gateway_id == null || var.customer_gateway_id == "" ? 1 : 0

  bgp_asn     = var.customer_gateway_bgp_asn
  ip_address  = var.customer_gateway_ip
  type        = var.customer_gateway_type
  device_name = var.customer_gateway_device_name
  tags        = var.tags
}

resource "aws_vpn_gateway" "this" {
  count = var.create_vpn_gateway ? 1 : 0

  vpc_id          = var.vpc_id
  amazon_side_asn = var.vpn_gateway_amazon_side_asn
  tags            = var.tags
}

resource "aws_vpn_connection" "this" {
  customer_gateway_id = local.customer_gateway_id
  type                = var.vpn_connection_type
  static_routes_only  = var.static_routes_only

  transit_gateway_id = local.use_transit_gateway ? var.transit_gateway_id : null
  vpn_gateway_id     = local.use_transit_gateway ? null : local.vpn_gateway_id

  local_ipv4_network_cidr  = var.local_ipv4_network_cidr
  remote_ipv4_network_cidr = var.remote_ipv4_network_cidr
  local_ipv6_network_cidr  = var.local_ipv6_network_cidr
  remote_ipv6_network_cidr = var.remote_ipv6_network_cidr

  tunnel1_inside_cidr      = var.tunnel1_inside_cidr
  tunnel2_inside_cidr      = var.tunnel2_inside_cidr
  tunnel1_inside_ipv6_cidr = var.tunnel1_inside_ipv6_cidr
  tunnel2_inside_ipv6_cidr = var.tunnel2_inside_ipv6_cidr
  tunnel1_preshared_key    = var.tunnel1_preshared_key
  tunnel2_preshared_key    = var.tunnel2_preshared_key
  tunnel1_ike_versions     = var.tunnel1_ike_versions
  tunnel2_ike_versions     = var.tunnel2_ike_versions

  tunnel1_phase1_dh_group_numbers      = var.tunnel1_phase1_dh_group_numbers
  tunnel2_phase1_dh_group_numbers      = var.tunnel2_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms = var.tunnel1_phase1_encryption_algorithms
  tunnel2_phase1_encryption_algorithms = var.tunnel2_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.tunnel1_phase1_integrity_algorithms
  tunnel2_phase1_integrity_algorithms  = var.tunnel2_phase1_integrity_algorithms
  tunnel1_phase1_lifetime_seconds      = var.tunnel1_phase1_lifetime_seconds
  tunnel2_phase1_lifetime_seconds      = var.tunnel2_phase1_lifetime_seconds

  tunnel1_phase2_dh_group_numbers      = var.tunnel1_phase2_dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = var.tunnel2_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = var.tunnel1_phase2_encryption_algorithms
  tunnel2_phase2_encryption_algorithms = var.tunnel2_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.tunnel1_phase2_integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = var.tunnel2_phase2_integrity_algorithms
  tunnel1_phase2_lifetime_seconds      = var.tunnel1_phase2_lifetime_seconds
  tunnel2_phase2_lifetime_seconds      = var.tunnel2_phase2_lifetime_seconds

  tunnel1_rekey_margin_time_seconds       = var.tunnel1_rekey_margin_time_seconds
  tunnel2_rekey_margin_time_seconds       = var.tunnel2_rekey_margin_time_seconds
  tunnel1_rekey_fuzz_percentage           = var.tunnel1_rekey_fuzz_percentage
  tunnel2_rekey_fuzz_percentage           = var.tunnel2_rekey_fuzz_percentage
  tunnel1_replay_window_size              = var.tunnel1_replay_window_size
  tunnel2_replay_window_size              = var.tunnel2_replay_window_size
  tunnel1_dpd_timeout_seconds             = var.tunnel1_dpd_timeout_seconds
  tunnel2_dpd_timeout_seconds             = var.tunnel2_dpd_timeout_seconds
  tunnel1_dpd_timeout_action              = var.tunnel1_dpd_timeout_action
  tunnel2_dpd_timeout_action              = var.tunnel2_dpd_timeout_action
  tunnel1_startup_action                  = var.tunnel1_startup_action
  tunnel2_startup_action                  = var.tunnel2_startup_action
  tunnel1_enable_tunnel_lifecycle_control = var.tunnel1_enable_tunnel_lifecycle_control
  tunnel2_enable_tunnel_lifecycle_control = var.tunnel2_enable_tunnel_lifecycle_control

  tags = var.tags
}

resource "aws_vpn_connection_route" "static" {
  for_each = var.static_routes_only ? toset(var.static_routes) : toset([])

  vpn_connection_id      = aws_vpn_connection.this.id
  destination_cidr_block = each.value
}
