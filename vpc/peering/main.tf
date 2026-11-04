locals {
  tags = merge(
    var.tags,
    var.name != null && var.name != "" ? { Name = var.name } : {}
  )

  use_inline_options = !var.manage_connection_options

  # A single AWS provider/account can't both create the connection and be the
  # accepter for a true cross-account peering — the requester side (this
  # account) creates it; a separate unit running under the peer account's own
  # provider accepts it by ID. manage_requester = false skips creation here.
  connection_id = var.manage_requester ? aws_vpc_peering_connection.peering[0].id : var.vpc_peering_connection_id
}

resource "aws_vpc_peering_connection" "peering" {
  count = var.manage_requester ? 1 : 0

  region = var.requester_region

  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.vpc_id
  auto_accept   = var.auto_accept
  peer_region   = var.peer_region

  dynamic "accepter" {
    for_each = local.use_inline_options ? var.accepter : []
    content {
      allow_remote_vpc_dns_resolution = accepter.value.allow_remote_vpc_dns_resolution
    }
  }

  dynamic "requester" {
    for_each = local.use_inline_options ? var.requester : []
    content {
      allow_remote_vpc_dns_resolution = requester.value.allow_remote_vpc_dns_resolution
    }
  }

  tags = local.tags
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  count = var.manage_accepter ? 1 : 0

  vpc_peering_connection_id = local.connection_id
  auto_accept               = var.accepter_auto_accept
  region                    = var.accepter_region
  tags                      = local.tags
}

resource "aws_vpc_peering_connection_options" "requester" {
  count = var.manage_connection_options && length(var.requester) > 0 ? 1 : 0

  region = var.requester_region

  vpc_peering_connection_id = var.manage_accepter ? aws_vpc_peering_connection_accepter.accepter[0].id : local.connection_id

  dynamic "requester" {
    for_each = var.requester
    content {
      allow_remote_vpc_dns_resolution = requester.value.allow_remote_vpc_dns_resolution
    }
  }

  # depends_on precisa de lista estática — não aceita ternário. Referenciar o
  # resource inteiro (sem índice) funciona com count=0 ou 1: cria a
  # dependência quando o accepter existe, e não cria nada quando não existe.
  depends_on = [aws_vpc_peering_connection_accepter.accepter]
}

resource "aws_vpc_peering_connection_options" "accepter" {
  count = var.manage_connection_options && length(var.accepter) > 0 ? 1 : 0

  vpc_peering_connection_id = var.manage_accepter ? aws_vpc_peering_connection_accepter.accepter[0].id : local.connection_id
  region                    = var.accepter_region

  dynamic "accepter" {
    for_each = var.accepter
    content {
      allow_remote_vpc_dns_resolution = accepter.value.allow_remote_vpc_dns_resolution
    }
  }

  # depends_on precisa de lista estática — não aceita ternário. Referenciar o
  # resource inteiro (sem índice) funciona com count=0 ou 1: cria a
  # dependência quando o accepter existe, e não cria nada quando não existe.
  depends_on = [aws_vpc_peering_connection_accepter.accepter]
}