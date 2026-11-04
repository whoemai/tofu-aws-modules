variable "peer_owner_id" {
  type        = string
  default     = null
  description = "(Optional) The AWS account ID of the owner of the peer VPC. Defaults to the account ID the AWS provider is currently connected to."
}

variable "peer_vpc_id" {
  type        = string
  default     = ""
  description = "(Required) The ID of the VPC with which you are creating the VPC Peering Connection."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "(Required) The ID of the requester VPC."
}

variable "auto_accept" {
  type        = bool
  default     = true
  description = "Optional) Accept the peering (both VPCs need to be in the same AWS account and region)."
}

variable "peer_region" {
  type        = string
  default     = null
  description = "(Optional) The region of the accepter VPC of the VPC Peering Connection. auto_accept must be false, and use the aws_vpc_peering_connection_accepter to manage the accepter side."
}

variable "accepter" {
  type = list(object({
    allow_remote_vpc_dns_resolution = bool
  }))
  default     = []
  description = "(Optional) - An optional configuration block that allows for [VPC Peering Connection] (https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) options to be set for the VPC that accepts the peering connection (a maximum of one)."
}

variable "requester" {
  type = list(object({
    allow_remote_vpc_dns_resolution = bool
  }))
  default     = []
  description = "(Optional) - A optional configuration block that allows for [VPC Peering Connection] (https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) options to be set for the VPC that requests the peering connection (a maximum of one)."
}

variable "manage_connection_options" {
  type        = bool
  default     = false
  description = "Whether to manage VPC peering options via aws_vpc_peering_connection_options (recommended for cross-account/region)."
}

variable "manage_accepter" {
  type        = bool
  default     = false
  description = "Whether to manage the accepter side using aws_vpc_peering_connection_accepter."
}

variable "manage_requester" {
  type        = bool
  default     = true
  description = "Whether this unit creates the peering connection itself (true, requester side) or only accepts/manages options against an existing connection created elsewhere (false). Set to false for a true cross-account accepter-side unit, where the connection was created by a separate unit running under the peer account's own provider/exec role — a single aws_vpc_peering_connection cannot be created under one account's credentials and accepted under another's in the same apply."
}

variable "vpc_peering_connection_id" {
  type        = string
  default     = null
  description = "(Required when manage_requester = false) ID of an existing VPC peering connection to accept/manage options for, typically the `id` output of the requester-side unit in the peer account."

  validation {
    condition     = var.manage_requester || var.vpc_peering_connection_id != null
    error_message = "vpc_peering_connection_id is required when manage_requester = false."
  }
}

variable "accepter_auto_accept" {
  type        = bool
  default     = true
  description = "Whether the accepter side auto-accepts the peering request."
}

variable "accepter_region" {
  type        = string
  default     = null
  description = "Region for the accepter-side resources (aws_vpc_peering_connection_accepter and the accepter options resource) when a single provider manages multiple regions. Defaults to the region set in the provider configuration."
}

variable "requester_region" {
  type        = string
  default     = null
  description = "Region for the requester-side resources (aws_vpc_peering_connection and the requester options resource) when a single provider manages multiple regions. Defaults to the region set in the provider configuration. Symmetric with accepter_region."
}

variable "validate_peer_region" {
  type        = bool
  default     = true
  description = "Whether to validate peer_region and auto_accept combination."

  validation {
    condition = (
      !var.validate_peer_region ||
      var.peer_region == null || var.peer_region == "" ||
      var.auto_accept == false
    )
    error_message = "peer_region requires auto_accept = false and an accepter-side resource when inter-region."
  }
}

variable "validate_options_acceptance" {
  type        = bool
  default     = true
  description = "Whether to validate option management against acceptance settings."

  validation {
    condition = (
      !var.validate_options_acceptance ||
      !var.manage_connection_options ||
      var.auto_accept ||
      var.manage_accepter ||
      var.manage_requester
    )
    error_message = "When manage_connection_options is true and auto_accept is false, manage_accepter must be true, or this must be the requester-side unit (manage_requester = true) — in a two-account setup the requester-side options resource only succeeds once the peer account's accepter unit has accepted the connection, so expect this to need a second apply after that."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the peering resources."
}

variable "name" {
  type        = string
  default     = ""
  description = "Optional Name tag value for the peering connection."
}