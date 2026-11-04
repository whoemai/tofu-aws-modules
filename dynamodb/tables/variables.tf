variable "tables" {
  description = <<-EOT
    Mapa de tabelas: chave = nome da tabela, valor = objeto com:
      hash_key                 — nome do atributo de partição
      range_key                — opcional, atributo de ordenação
      attributes               — lista de {name, type} SÓ dos atributos usados em chave
                                 (tabela, GSI ou LSI). type = "S" | "N" | "B"
      global_secondary_indexes — opcional, lista de {name, hash_key, range_key,
                                 projection_type, non_key_attributes}
      local_secondary_indexes  — opcional, lista de {name, range_key, projection_type,
                                 non_key_attributes}
      ttl_attribute            — opcional, nome do atributo de TTL
  EOT
  type = map(object({
    hash_key  = string
    range_key = optional(string)
    attributes = list(object({
      name = string
      type = string
    }))
    global_secondary_indexes = optional(list(object({
      name               = string
      hash_key           = string
      range_key          = optional(string)
      projection_type    = optional(string, "ALL")
      non_key_attributes = optional(list(string))
    })), [])
    local_secondary_indexes = optional(list(object({
      name               = string
      range_key          = string
      projection_type    = optional(string, "ALL")
      non_key_attributes = optional(list(string))
    })), [])
    ttl_attribute = optional(string)
  }))
}

variable "point_in_time_recovery" {
  description = "Habilita Point-in-Time Recovery (PITR) em todas as tabelas."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags aplicadas a todas as tabelas"
  type        = map(string)
  default     = {}
}
