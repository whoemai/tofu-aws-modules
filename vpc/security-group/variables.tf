variable "sg_name" {
  description = "Security Group name"
  type        = string
}

variable "sg_description" {
  description = "Security Group description"
  type        = string
  default     = "Security group managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where the Security Group will be created"
  type        = string
}

variable "ingress_rules" {
  description = <<EOT
List of ingress rules. Each rule supports:
- description        (optional)
- from_port          (required)
- to_port            (required)
- protocol           (required, e.g., 'tcp', 'udp', '-1')
- cidr_blocks        (optional, list of CIDRs)
- ipv6_cidr_blocks   (optional, list of IPv6 CIDRs)
- security_groups    (optional, list of SG IDs; must be in same VPC)
- self               (optional, bool — regra aponta pro próprio security group. Não é o
                       mesmo que colocar o próprio ID em security_groups: o provider AWS
                       gera uma tupla de regra diferente pra cada forma, então usar o ID
                       literal onde o recurso real foi criado com self=true força
                       revoke+authorize no plan mesmo sendo o mesmo efeito final.)
EOT
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []
}

variable "create_egress_rule" {
  description = "Se falso, o security group não recebe nenhuma regra de egress (ex.: SG do control plane do EKS, que é criado com zero egress pelo EKS)."
  type        = bool
  default     = true
}

variable "egress_description" {
  description = "Egress rule description"
  type        = string
  default     = "Allow all outbound"
}

variable "egress_from_port" {
  description = "Egress from port"
  type        = number
  default     = 0
}

variable "egress_to_port" {
  description = "Egress to port"
  type        = number
  default     = 0
}

variable "egress_protocol" {
  description = "Egress protocol ('-1' for all)"
  type        = string
  default     = "-1"
}

variable "egress_cidr_blocks" {
  description = "Egress IPv4 CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_ipv6_cidr_blocks" {
  description = "Egress IPv6 CIDR blocks"
  type        = list(string)
  default     = ["::/0"]
}

variable "tags" {
  description = "Tags to apply to the Security Group"
  type        = map(string)
  default     = {}
}