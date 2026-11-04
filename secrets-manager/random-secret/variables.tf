variable "name" {
  description = "Nome exato do secret (ex. \"projeto/rds/db-projeto/master\")"
  type        = string
}

variable "description" {
  description = "Descrição do secret"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "(Opcional) ARN/ID da CMK que cifra o secret. Null usa a key gerenciada aws/secretsmanager."
  type        = string
  default     = null
}

variable "length" {
  description = "Tamanho da senha gerada"
  type        = number
  default     = 32
}

variable "override_special" {
  description = "Conjunto de caracteres especiais permitidos na senha gerada"
  type        = string
  default     = "!#$*-_=+[]{}<>:?"
}

variable "secret_string_template" {
  description = <<-EOT
    Forma do secret_string quando o consumidor exige uma estrutura (JSON/properties)
    em vez da senha pura. Use `password_token` no campo sensível, ex.:
    `jsonencode({ username = "admin", password = "__PASSWORD__" })`. Null grava só a
    senha, sem estrutura nenhuma.
  EOT
  type        = string
  default     = null
}

variable "password_token" {
  description = "Marcador que o módulo troca pela senha real dentro de secret_string_template."
  type        = string
  default     = "__PASSWORD__"
}

variable "tags" {
  description = "Tags do secret"
  type        = map(string)
  default     = {}
}
