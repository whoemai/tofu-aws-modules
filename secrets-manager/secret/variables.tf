variable "name" {
  description = "Nome do secret no Secrets Manager (ex. \"prod/app/auth\")"
  type        = string
}

variable "description" {
  description = "Descrição do secret"
  type        = string
  default     = null
}

variable "initial_value" {
  description = <<-EOT
    Valor inicial opcional; string JSON/properties de placeholder quando a aplicação exige
    formato válido no boot (ex. `{}`). Use `__PLACEHOLDER__` nos campos sensíveis — o módulo
    substitui cada token pelo placeholder gerado.
  EOT
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags aplicadas ao secret"
  type        = map(string)
  default     = {}
}

variable "placeholder_prefix" {
  description = <<-EOT
    Prefixo do valor inicial quando `initial_value` não define um. O valor final é
    `<prefixo>-<24 chars aleatórios>`: o prefixo permite identificar valores ainda não
    preenchidos e o sufixo impede que o placeholder seja um valor estático conhecido.
  EOT
  type        = string
  default     = "PREENCHER-FORA-DO-TERRAFORM"
}

variable "placeholder_token" {
  description = <<-EOT
    Marcador que o módulo substitui pelo placeholder dentro de `initial_value`. Use nos campos
    sensíveis do JSON/properties declarado na unit (ex. `{"api-key":"__PLACEHOLDER__"}`).
  EOT
  type        = string
  default     = "__PLACEHOLDER__"
}
