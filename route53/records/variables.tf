variable "zone_id" {
  description = "ID da hosted zone (dependency.hosted_zone.outputs.zone_id)"
  type        = string
}

variable "name" {
  description = "Nome do registro, relativo à zona (ex. \"db\") ou FQDN — o Route53 resolve relativo à zona."
  type        = string
}

variable "type" {
  description = "Tipo do registro (A, AAAA, CAA, CNAME, DS, HTTPS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, SSHFP, SVCB, TLSA, TXT)."
  type        = string
  default     = "CNAME"
}

variable "records" {
  description = "Valores do registro. Obrigatório se `alias` não for definido; conflita com `alias`."
  type        = list(string)
  default     = null
}

variable "ttl" {
  description = <<-EOT
    TTL do registro. Ignorado (e não deve ser setado) em registro alias.
    Sem default fixo aqui — 60s de propósito em usos de CNAME de infra
    (RDS/Redis): quando o recurso é recriado o endpoint muda, e TTL longo
    faria os pods carregarem um IP morto por minutos depois do apply.
  EOT
  type        = number
  default     = 60
}

variable "alias" {
  description = "Alvo alias (ALB/NLB, CloudFront, S3 website, outra hosted zone). Conflita com `records`/`ttl` no provider."
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = optional(bool, true)
  })
  default = null
}

variable "set_identifier" {
  description = "Obrigatório junto de qualquer routing policy abaixo."
  type        = string
  default     = null
}

variable "health_check_id" {
  description = "Health check associado ao registro."
  type        = string
  default     = null
}

variable "weighted_routing_policy" {
  type = object({
    weight = number
  })
  default = null
}

variable "failover_routing_policy" {
  type = object({
    type = string
  })
  default = null
}

variable "latency_routing_policy" {
  type = object({
    region = string
  })
  default = null
}

variable "geolocation_routing_policy" {
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  default = null
}

variable "geoproximity_routing_policy" {
  type = object({
    aws_region       = optional(string)
    bias             = optional(number)
    local_zone_group = optional(string)
    coordinates = optional(object({
      latitude  = string
      longitude = string
    }))
  })
  default = null
}

variable "multivalue_answer_routing_policy" {
  type    = bool
  default = null
}

variable "cidr_routing_policy" {
  type = object({
    collection_id = string
    location_name = string
  })
  default = null
}

variable "allow_overwrite" {
  description = <<-EOT
    Permite sobrescrever um registro pré-existente com o mesmo nome/tipo na zona.
    Default `true` porque o uso original deste módulo é registro de propriedade
    do próprio stack, onde uma recriação pode deixar um registro órfão pra trás.
    Outro projeto que precise de detecção estrita de conflito pode setar `false`.
  EOT
  type        = bool
  default     = true
}
