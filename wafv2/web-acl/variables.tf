variable "name" {
  description = "Nome da WebACL. Também vira o `metric_name` do CloudWatch, que só aceita [A-Za-z0-9-_]."
  type        = string
}

variable "description" {
  description = "Descrição da WebACL"
  type        = string
  default     = null
}

variable "scope" {
  description = "CLOUDFRONT (exige provider em us-east-1) ou REGIONAL (ALB, API Gateway, AppSync)."
  type        = string
  default     = "CLOUDFRONT"

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "scope deve ser CLOUDFRONT ou REGIONAL."
  }
}

variable "default_action" {
  description = "O que fazer com request que não casa com nenhuma rule: allow (padrão) ou block."
  type        = string
  default     = "allow"

  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "default_action deve ser allow ou block."
  }
}

variable "managed_rule_groups" {
  description = <<-EOT
    Managed rule groups da AWS (ou de vendor no Marketplace). A ORDEM da lista define a
    priority. `override_action = "none"` usa as ações do grupo; `"count"` só conta o match,
    pra observar o impacto antes de bloquear de verdade. `count_rules` lista rules
    DENTRO do grupo que viram `count` (falso-positivo pontual), mantendo as demais.
  EOT
  type = list(object({
    name            = string
    vendor_name     = optional(string, "AWS")
    override_action = optional(string, "none")
    count_rules     = optional(list(string), [])
  }))
  default = []
}

variable "label_block_rules" {
  description = <<-EOT
    Rules custom que BLOQUEIAM requests com um label emitido por managed rule group, exceto
    quando o URI path casa `except_uri_regex` (null = sem exceção). Par de `count_rules`: a
    rule do grupo vira count (só rotula) e esta re-bloqueia fora das rotas liberadas — exceção
    de falso-positivo por rota. `label` é o nome completo, ex.:
    "awswaf:managed:aws:core-rule-set:CrossSiteScripting_Body". Entram depois de todos os
    managed groups na priority; `name` também vira o metric_name ([A-Za-z0-9-_]).
  EOT
  type = list(object({
    name             = string
    label            = string
    except_uri_regex = optional(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.label_block_rules : can(regex("^[A-Za-z0-9_-]+$", r.name))])
    error_message = "label_block_rules[*].name só aceita [A-Za-z0-9-_] (vira metric_name)."
  }
}

variable "cloudwatch_metrics_enabled" {
  description = "Publica métricas por rule no CloudWatch — é o que permite ver o que a WebACL bloqueou."
  type        = bool
  default     = true
}

variable "sampled_requests_enabled" {
  description = "Guarda amostra das requests que casaram com cada rule, pra investigar falso-positivo no console."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}
