# `name_prefix` e não `name`: com `create_before_destroy` o novo SG nasce antes de o antigo
# sair, e nome fixo faz o replace falhar com `InvalidGroup.Duplicate`.
resource "aws_security_group" "this" {
  name_prefix = "${var.name}-"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = var.name })

  lifecycle {
    create_before_destroy = true
  }
}

# As regras ficam no mesmo módulo do SG de propósito: o grupo tem `create_before_destroy`, e
# regra vivendo em outro state continuaria apontando pro id antigo — o SG novo nasceria sem
# regra nenhuma e o tráfego cairia sem ninguém pedir mudança de rede.
#
# A chave do mapa é rótulo nosso, então renomear uma regra recria só ela.
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules

  security_group_id = aws_security_group.this.id

  description                  = coalesce(each.value.description, each.key)
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
}

# Sem nenhuma regra aqui o SG fica SEM egress: a AWS cria um allow-all ao criar o grupo, mas o
# provider remove esse default. Cache/banco que só recebe conexão não precisa; qualquer coisa
# que faça chamada de saída precisa declarar.
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules

  security_group_id = aws_security_group.this.id

  description                  = coalesce(each.value.description, each.key)
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
}
