# Mesma decisão de `recovery_window_in_days = 0` do secrets-manager/secret: com o
# default (7-30 dias) o nome fica agendado pra deleção e um `apply` logo depois de um
# `destroy` falha com InvalidRequestException ("scheduled for deletion").
resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  description             = var.description
  recovery_window_in_days = 0
  kms_key_id              = var.kms_key_id

  tags = merge(
    var.tags,
    { Name = var.name },
  )
}

resource "random_password" "this" {
  length           = var.length
  override_special = var.override_special
}

# Ao contrário do secrets-manager/secret (placeholder inerte, valor real preenchido
# fora do Terraform), aqui o valor É o segredo de verdade — pensado pra credenciais
# que o próprio Terraform precisa consumir na mesma apply (ex. master password de RDS
# passada de uma unit pra outra via dependency), não pra segredos de app via ESO.
resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id

  secret_string = replace(
    coalesce(var.secret_string_template, var.password_token),
    var.password_token,
    random_password.this.result,
  )
}
