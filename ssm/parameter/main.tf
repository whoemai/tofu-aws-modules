# Uma unit por parametro — mesma logica do secrets-manager/secret, kms/key e
# route53/record. Complementa (nao substitui) o ssm/parameters: aquele continua sendo
# o jeito certo pra managed_parameters (config nao sensivel, varios paths por unit);
# este e so pro caso SEGREDO isolado.
#
# Placeholder com sufixo aleatorio: precisa ser reconhecivel (`grep` no prefixo acha)
# sem ser um valor conhecido fora do state. Ver o historico completo no
# ssm/parameters/main.tf — foi uma constante fixa ali que virou senha real e publica.
resource "random_password" "placeholder" {
  length  = 24
  special = false
}

resource "aws_ssm_parameter" "this" {
  name        = var.name
  type        = var.type
  description = var.description
  value       = "${var.placeholder_prefix}-${random_password.placeholder.result}"
  tier        = var.tier

  tags = merge(var.tags, { Name = var.name })

  # `all`, nao `[value]`: o provider manda `Value` em todo `PutParameter` de update,
  # inclusive num update disparado so por `description`/`tier`. Com `[value]`, editar a
  # descricao de um path ja preenchido reescreve o segredo de volta pro placeholder.
  # O preco: mudar `description`/`tier`/`type`/`tags` de um path ja criado vira no-op no
  # plan — pra mudar de verdade e preciso recriar o parametro (apaga o valor real).
  lifecycle {
    ignore_changes = all
  }
}
