output "id" {
  value = local.connection_id
}

output "accept_status" {
  value = var.manage_requester ? aws_vpc_peering_connection.peering[0].accept_status : try(aws_vpc_peering_connection_accepter.accepter[0].accept_status, null)
}

output "accepter_id" {
  value = var.manage_accepter ? aws_vpc_peering_connection_accepter.accepter[0].id : null
}

output "requester_options_id" {
  value = try(aws_vpc_peering_connection_options.requester[0].id, null)
}

output "accepter_options_id" {
  value = try(aws_vpc_peering_connection_options.accepter[0].id, null)
}
