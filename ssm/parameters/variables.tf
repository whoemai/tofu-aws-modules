variable "parameters" {
  description = <<-EOT
    Parâmetros SEGREDO — criados com placeholder e ignorados em updates subsequentes pelo
    Terraform (`ignore_changes = all`, ver main.tf). Chave = path completo (ex.
    "/prod/app/db/password"), valor = objeto com:
      type        — "String", "StringList" ou "SecureString"
      description — opcional, texto livre; considerado apenas na criação
      tier        — opcional, default "Standard"
  EOT
  type = map(object({
    type        = string
    description = optional(string)
    tier        = optional(string, "Standard")
  }))
  default = {}
}

variable "managed_parameters" {
  description = <<-EOT
    Parâmetros de CONFIGURAÇÃO não sensível, com valor gerido pelo Terraform (sem
    `ignore_changes`). Use apenas para valores não sensíveis: endpoint de banco,
    bootstrap servers do Kafka, URL interna.
    Chave = path completo, valor = objeto com type, value, description, tier.
  EOT
  type = map(object({
    type        = string
    value       = string
    description = optional(string)
    tier        = optional(string, "Standard")
  }))
  default = {}
}

variable "placeholder_prefix" {
  description = <<-EOT
    Prefixo do valor inicial de todo parâmetro de `var.parameters`. O valor final é
    `<prefixo>-<24 chars aleatórios>` — o prefixo identifica parâmetros pendentes de
    preenchimento e o sufixo garante que o placeholder não seja um valor fixo conhecido.
  EOT
  type        = string
  default     = "PREENCHER-FORA-DO-TERRAFORM"
}

variable "tags" {
  description = "Tags aplicadas a todos os parâmetros"
  type        = map(string)
  default     = {}
}
