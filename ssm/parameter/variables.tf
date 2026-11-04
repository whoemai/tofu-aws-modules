variable "name" {
  description = "Path completo do parametro (ex. \"/prod/app/db/password\")"
  type        = string
}

variable "type" {
  description = "Tipo do parametro no SSM: \"String\", \"StringList\" ou \"SecureString\""
  type        = string
}

variable "description" {
  description = "Descricao do parametro. So vale na CRIACAO — o lifecycle ignora update, editar depois e no-op silencioso no plan"
  type        = string
  default     = null
}

variable "tier" {
  description = "Tier do parametro no SSM"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags do parametro"
  type        = map(string)
  default     = {}
}

variable "placeholder_prefix" {
  description = <<-EOT
    Prefixo do valor inicial do parametro. O valor final e `<prefixo>-<24 chars
    aleatorios>` — o prefixo e o sinal (reconhecivel em log de app, e o que o gate do
    seed e o `scripts/segredos.sh` procuram) e o sufixo garante que o placeholder nao
    seja um valor conhecido fora do state.

    Nao transforme isto de volta num valor completo e fixo: foi assim que o placeholder
    virou senha real e publica de um usuario MySQL (ver `ssm/parameters/main.tf`).
  EOT
  type        = string
  default     = "PREENCHER-FORA-DO-TERRAFORM"
}
