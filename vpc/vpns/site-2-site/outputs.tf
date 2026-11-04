output "vpn_connection_id" {
  value = aws_vpn_connection.this.id
}

output "vpn_connection_arn" {
  value = aws_vpn_connection.this.arn
}

output "customer_gateway_id" {
  value = local.customer_gateway_id
}

output "vpn_gateway_id" {
  value = local.use_transit_gateway ? null : local.vpn_gateway_id
}

output "transit_gateway_id" {
  value = local.use_transit_gateway ? var.transit_gateway_id : null
}

output "tunnel1_address" {
  value = aws_vpn_connection.this.tunnel1_address
}

output "tunnel2_address" {
  value = aws_vpn_connection.this.tunnel2_address
}

output "customer_gateway_configuration" {
  value     = aws_vpn_connection.this.customer_gateway_configuration
  sensitive = true
}
