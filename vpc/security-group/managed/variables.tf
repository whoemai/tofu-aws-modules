variable "name" {
  description = <<-EOT
    Base do nome do SG e valor da tag `Name`. O nome real ganha sufixo aleatório
    (`name_prefix`), obrigatório por causa do `create_before_destroy` — quem procura o grupo
    no console procura pela tag.
  EOT
  type        = string
}

variable "description" {
  description = <<-EOT
    Descrição do SG. É forced-new (a AWS não deixa editar depois da criação) e não aceita
    acento nem caractere fora de `a-zA-Z0-9 ._-:/()#,@[]+=&;{}!$*`.
  EOT
  type        = string
}

variable "vpc_id" {
  description = "VPC onde o SG é criado (`dependency.network.outputs.vpc_id`)."
  type        = string
}

variable "ingress_rules" {
  description = <<-EOT
    Regras de entrada, uma por chave do mapa. A chave é rótulo nosso (vira a `description` da
    regra quando ela não é informada) e é o que estabiliza o `for_each`: reordenar não recria.

    Cada regra precisa de **exatamente uma** origem — `cidr_ipv4`, `cidr_ipv6`,
    `prefix_list_id` ou `referenced_security_group_id`. `ip_protocol = "-1"` (todos) exige
    `from_port` e `to_port` nulos.
  EOT
  type = map(object({
    description                  = optional(string)
    ip_protocol                  = optional(string, "tcp")
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, r in var.ingress_rules :
      length([
        for source in [r.cidr_ipv4, r.cidr_ipv6, r.prefix_list_id, r.referenced_security_group_id] :
        source if source != null
      ]) == 1
    ])
    error_message = "Cada regra de ingress precisa de exatamente uma origem: cidr_ipv4, cidr_ipv6, prefix_list_id ou referenced_security_group_id."
  }

  validation {
    condition = alltrue([
      for k, r in var.ingress_rules :
      r.ip_protocol == "-1" ? r.from_port == null && r.to_port == null : r.from_port != null && r.to_port != null
    ])
    error_message = "Regra de ingress com ip_protocol \"-1\" não aceita from_port/to_port; com tcp/udp os dois são obrigatórios."
  }
}

variable "egress_rules" {
  description = <<-EOT
    Regras de saída, mesmo formato do `ingress_rules`. Mapa vazio deixa o SG **sem egress
    nenhum** — a AWS cria um allow-all na criação do grupo e o provider remove.

    Liberação total é `{ all = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" } }`.
  EOT
  type = map(object({
    description                  = optional(string)
    ip_protocol                  = optional(string, "tcp")
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, r in var.egress_rules :
      length([
        for destination in [r.cidr_ipv4, r.cidr_ipv6, r.prefix_list_id, r.referenced_security_group_id] :
        destination if destination != null
      ]) == 1
    ])
    error_message = "Cada regra de egress precisa de exatamente um destino: cidr_ipv4, cidr_ipv6, prefix_list_id ou referenced_security_group_id."
  }

  validation {
    condition = alltrue([
      for k, r in var.egress_rules :
      r.ip_protocol == "-1" ? r.from_port == null && r.to_port == null : r.from_port != null && r.to_port != null
    ])
    error_message = "Regra de egress com ip_protocol \"-1\" não aceita from_port/to_port; com tcp/udp os dois são obrigatórios."
  }
}

variable "tags" {
  description = "Tags aplicadas ao security group."
  type        = map(string)
  default     = {}
}
