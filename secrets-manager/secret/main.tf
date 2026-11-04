# `recovery_window_in_days = 0` de propósito: com o default (7-30 dias) o nome fica agendado
# pra deleção e um `apply` logo depois de um `destroy` falha com InvalidRequestException
# ("scheduled for deletion").
#
# Os consumidores devem referenciar o secret por NOME, não por ARN — o sufixo aleatório do ARN
# muda a cada recriação.
resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  description             = var.description
  recovery_window_in_days = 0

  tags = merge(
    var.tags,
    { Name = var.name },
  )
}

# Placeholder com sufixo aleatório, mesma decisão do ssm/parameters (o porquê completo está lá).
resource "random_password" "placeholder" {
  length  = 24
  special = false
}

# O segredo precisa EXISTIR pro ESO montar o Secret (sem ele o pod fica em ContainerCreating),
# mas o valor real nunca passa pelo state.
resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id

  # Um `replace` cobre os dois casos, sem condicional:
  #   sem `initial_value` -> a string é só o token, e o replace devolve o placeholder;
  #   com `initial_value` -> cada `__PLACEHOLDER__` dentro do JSON/properties da unit vira o
  #                          placeholder, preservando a forma que o app exige.
  #
  # Todas as chaves de um mesmo secret recebem o mesmo sufixo — nenhuma delas é pra ser usada
  # como credencial, o que importa é o valor não existir fora do state.
  secret_string = replace(
    coalesce(var.initial_value, var.placeholder_token),
    var.placeholder_token,
    "${var.placeholder_prefix}-${random_password.placeholder.result}",
  )

  # `[secret_string]` e não `all`, ao contrário do ssm/parameters: aqui o único atributo
  # atualizável in-place é `version_stages`, que vira `UpdateSecretVersionStage` e não toca no
  # conteúdo. Não existe update que reescreva o valor por tabela.
  lifecycle {
    ignore_changes = [secret_string]
  }
}
