variable "vpc_id" {
  type        = string
  description = "(Required) The VPC ID."
}

variable "routes" {
  type = list(object({
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    destination_prefix_list_id  = optional(string)
    carrier_gateway_id          = optional(string)
    core_network_arn            = optional(string)
    egress_only_gateway_id      = optional(string)
    gateway_id                  = optional(string)
    local_gateway_id            = optional(string)
    nat_gateway_id              = optional(string)
    network_interface_id        = optional(string)
    transit_gateway_id          = optional(string)
    vpc_endpoint_id             = optional(string)
    vpc_peering_connection_id   = optional(string)
  }))
  default     = []
  description = "(Optional) A list of route objects. This is processed in attribute-as-blocks mode."

  validation {
    condition = alltrue([
      for route in var.routes : !(
        try(route.gateway_id, null) != null && try(route.nat_gateway_id, null) != null
      )
    ])
    error_message = "Each route can set either gateway_id or nat_gateway_id, not both."
  }
}

variable "subnet_associations" {
  type        = list(string)
  default     = []
  description = "(Optional) List of subnet IDs to associate with the route table."
}

variable "gateway_associations" {
  type        = list(string)
  default     = []
  description = "(Optional) List of gateway IDs (IGW or VGW) to associate with the route table."
}

variable "propagating_vgws" {
  type        = list(string)
  default     = []
  description = "(Optional) List of virtual gateways for route propagation."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
