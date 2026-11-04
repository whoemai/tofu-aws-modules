# Parameter Store. Dois recursos porque `ignore_changes` é estático em HCL:
#   var.parameters         — SEGREDO: nasce com placeholder e o Terraform nunca mais toca nele.
#   var.managed_parameters — CONFIGURAÇÃO: valor não sensível, gerenciado normalmente.

# Placeholder com sufixo aleatório: precisa ser reconhecível (`grep` no prefixo acha) sem ser
# um valor conhecido fora do state. Com uma constante versionada no repo, o seed acabou usando
# o placeholder como senha real de um usuário MySQL.
#
# `special = false`: se o valor for usado como senha por acidente, caractere especial em URL de
# JDBC troca um "Access denied" legível por erro de parse a três camadas de distância.
resource "random_password" "placeholder" {
  for_each = var.parameters

  length  = 24
  special = false
}

resource "aws_ssm_parameter" "secret" {
  for_each = var.parameters

  name        = each.key
  type        = each.value.type
  description = each.value.description
  value       = "${var.placeholder_prefix}-${random_password.placeholder[each.key].result}"
  tier        = each.value.tier

  tags = merge(var.tags, { Name = each.key })

  # `all`, não `[value]`: o provider manda `Value` em todo `PutParameter` de update, inclusive
  # num update disparado só por `description`/`tier`. Com `[value]`, editar a descrição de um
  # path já preenchido reescreve o segredo de volta pro placeholder.
  # O preço: mudar `description`/`tier`/`type`/`tags` de um path de segredo vira no-op no plan.
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ssm_parameter" "managed" {
  for_each = var.managed_parameters

  name        = each.key
  type        = each.value.type
  description = each.value.description
  value       = each.value.value
  tier        = each.value.tier

  tags = merge(var.tags, { Name = each.key })
}
