output "id" {
  description = "NAT Gateway ID."
  value       = aws_nat_gateway.gw.id
}

output "public_ip" {
  description = "Public IP for a public, zonal NAT gateway."
  value       = aws_nat_gateway.gw.public_ip
}

output "network_interface_id" {
  description = "Network interface ID for a zonal NAT gateway."
  value       = aws_nat_gateway.gw.network_interface_id
}

output "association_id" {
  description = "EIP association ID for a public, zonal NAT gateway."
  value       = aws_nat_gateway.gw.association_id
}

output "route_table_id" {
  description = "Route table ID automatically created for a regional NAT gateway."
  value       = aws_nat_gateway.gw.route_table_id
}

output "regional_nat_gateway_address" {
  description = "Regional NAT gateway address blocks (regional mode only)."
  value       = aws_nat_gateway.gw.regional_nat_gateway_address
}

output "auto_provision_zones" {
  description = "Whether AWS auto-manages AZ coverage for regional NAT gateways."
  value       = aws_nat_gateway.gw.auto_provision_zones
}

output "auto_scaling_ips" {
  description = "Whether AWS auto-allocates extra EIPs for regional NAT gateways."
  value       = aws_nat_gateway.gw.auto_scaling_ips
}
