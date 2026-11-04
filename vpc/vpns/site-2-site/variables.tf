variable "create_vpn_gateway" {
  type        = bool
  default     = false
  description = "Whether to create a VPN gateway (VGW)."
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "VPC ID to attach the VPN gateway when create_vpn_gateway is true."
}

variable "vpn_gateway_id" {
  type        = string
  default     = null
  description = "Existing VPN gateway (VGW) ID to attach the VPN connection."
}

variable "vpn_gateway_amazon_side_asn" {
  type        = number
  default     = null
  description = "Amazon side ASN for the VPN gateway."
}

variable "transit_gateway_id" {
  type        = string
  default     = null
  description = "Transit Gateway ID to attach the VPN connection."
}

variable "customer_gateway_id" {
  type        = string
  default     = null
  description = "Existing customer gateway ID. If not provided, a new customer gateway is created."
}

variable "customer_gateway_ip" {
  type        = string
  default     = null
  description = "Public IPv4 address for the customer gateway. Required when customer_gateway_id is not set."
}

variable "customer_gateway_bgp_asn" {
  type        = number
  default     = 65000
  description = "BGP ASN for the customer gateway."
}

variable "customer_gateway_type" {
  type        = string
  default     = "ipsec.1"
  description = "Customer gateway type."

  validation {
    condition     = contains(["ipsec.1"], var.customer_gateway_type)
    error_message = "customer_gateway_type must be ipsec.1."
  }
}

variable "customer_gateway_device_name" {
  type        = string
  default     = null
  description = "Device name for the customer gateway."
}

variable "vpn_connection_type" {
  type        = string
  default     = "ipsec.1"
  description = "VPN connection type."

  validation {
    condition     = contains(["ipsec.1"], var.vpn_connection_type)
    error_message = "vpn_connection_type must be ipsec.1."
  }
}

variable "static_routes_only" {
  type        = bool
  default     = false
  description = "Whether to use static routes only (no BGP)."
}

variable "static_routes" {
  type        = list(string)
  default     = []
  description = "List of static route destination CIDRs for the VPN connection."
}

variable "local_ipv4_network_cidr" {
  type        = string
  default     = null
  description = "IPv4 CIDR on the customer gateway side."
}

variable "remote_ipv4_network_cidr" {
  type        = string
  default     = null
  description = "IPv4 CIDR on the AWS side."
}

variable "local_ipv6_network_cidr" {
  type        = string
  default     = null
  description = "IPv6 CIDR on the customer gateway side."
}

variable "remote_ipv6_network_cidr" {
  type        = string
  default     = null
  description = "IPv6 CIDR on the AWS side."
}

variable "tunnel1_inside_cidr" {
  type        = string
  default     = null
  description = "Inside IPv4 CIDR for tunnel 1 (/30 within 169.254.0.0/16)."
}

variable "tunnel2_inside_cidr" {
  type        = string
  default     = null
  description = "Inside IPv4 CIDR for tunnel 2 (/30 within 169.254.0.0/16)."
}

variable "tunnel1_inside_ipv6_cidr" {
  type        = string
  default     = null
  description = "Inside IPv6 CIDR for tunnel 1 (/126 within fd00::/8)."
}

variable "tunnel2_inside_ipv6_cidr" {
  type        = string
  default     = null
  description = "Inside IPv6 CIDR for tunnel 2 (/126 within fd00::/8)."
}

variable "tunnel1_preshared_key" {
  type        = string
  default     = null
  description = "Preshared key for tunnel 1."
}

variable "tunnel2_preshared_key" {
  type        = string
  default     = null
  description = "Preshared key for tunnel 2."
}

variable "tunnel1_ike_versions" {
  type        = list(string)
  default     = null
  description = "IKE versions for tunnel 1 (ikev1 or ikev2)."
}

variable "tunnel2_ike_versions" {
  type        = list(string)
  default     = null
  description = "IKE versions for tunnel 2 (ikev1 or ikev2)."
}

variable "tunnel1_phase1_dh_group_numbers" {
  type        = list(number)
  default     = null
  description = "Phase 1 DH group numbers for tunnel 1."
}

variable "tunnel2_phase1_dh_group_numbers" {
  type        = list(number)
  default     = null
  description = "Phase 1 DH group numbers for tunnel 2."
}

variable "tunnel1_phase1_encryption_algorithms" {
  type        = list(string)
  default     = null
  description = "Phase 1 encryption algorithms for tunnel 1."
}

variable "tunnel2_phase1_encryption_algorithms" {
  type        = list(string)
  default     = null
  description = "Phase 1 encryption algorithms for tunnel 2."
}

variable "tunnel1_phase1_integrity_algorithms" {
  type        = list(string)
  default     = null
  description = "Phase 1 integrity algorithms for tunnel 1."
}

variable "tunnel2_phase1_integrity_algorithms" {
  type        = list(string)
  default     = null
  description = "Phase 1 integrity algorithms for tunnel 2."
}

variable "tunnel1_phase1_lifetime_seconds" {
  type        = number
  default     = null
  description = "Phase 1 lifetime (seconds) for tunnel 1."
}

variable "tunnel2_phase1_lifetime_seconds" {
  type        = number
  default     = null
  description = "Phase 1 lifetime (seconds) for tunnel 2."
}

variable "tunnel1_phase2_dh_group_numbers" {
  type        = list(number)
  default     = null
  description = "Phase 2 DH group numbers for tunnel 1."
}

variable "tunnel2_phase2_dh_group_numbers" {
  type        = list(number)
  default     = null
  description = "Phase 2 DH group numbers for tunnel 2."
}

variable "tunnel1_phase2_encryption_algorithms" {
  type        = list(string)
  default     = null
  description = "Phase 2 encryption algorithms for tunnel 1."
}

variable "tunnel2_phase2_encryption_algorithms" {
  type        = list(string)
  default     = null
  description = "Phase 2 encryption algorithms for tunnel 2."
}

variable "tunnel1_phase2_integrity_algorithms" {
  type        = list(string)
  default     = null
  description = "Phase 2 integrity algorithms for tunnel 1."
}

variable "tunnel2_phase2_integrity_algorithms" {
  type        = list(string)
  default     = null
  description = "Phase 2 integrity algorithms for tunnel 2."
}

variable "tunnel1_phase2_lifetime_seconds" {
  type        = number
  default     = null
  description = "Phase 2 lifetime (seconds) for tunnel 1."
}

variable "tunnel2_phase2_lifetime_seconds" {
  type        = number
  default     = null
  description = "Phase 2 lifetime (seconds) for tunnel 2."
}

variable "tunnel1_rekey_margin_time_seconds" {
  type        = number
  default     = null
  description = "Rekey margin time (seconds) for tunnel 1."
}

variable "tunnel2_rekey_margin_time_seconds" {
  type        = number
  default     = null
  description = "Rekey margin time (seconds) for tunnel 2."
}

variable "tunnel1_rekey_fuzz_percentage" {
  type        = number
  default     = null
  description = "Rekey fuzz percentage for tunnel 1."
}

variable "tunnel2_rekey_fuzz_percentage" {
  type        = number
  default     = null
  description = "Rekey fuzz percentage for tunnel 2."
}

variable "tunnel1_replay_window_size" {
  type        = number
  default     = null
  description = "Replay window size for tunnel 1."
}

variable "tunnel2_replay_window_size" {
  type        = number
  default     = null
  description = "Replay window size for tunnel 2."
}

variable "tunnel1_dpd_timeout_seconds" {
  type        = number
  default     = null
  description = "DPD timeout (seconds) for tunnel 1."
}

variable "tunnel2_dpd_timeout_seconds" {
  type        = number
  default     = null
  description = "DPD timeout (seconds) for tunnel 2."
}

variable "tunnel1_dpd_timeout_action" {
  type        = string
  default     = null
  description = "DPD timeout action for tunnel 1."
}

variable "tunnel2_dpd_timeout_action" {
  type        = string
  default     = null
  description = "DPD timeout action for tunnel 2."
}

variable "tunnel1_startup_action" {
  type        = string
  default     = null
  description = "Startup action for tunnel 1."
}

variable "tunnel2_startup_action" {
  type        = string
  default     = null
  description = "Startup action for tunnel 2."
}

variable "tunnel1_enable_tunnel_lifecycle_control" {
  type        = bool
  default     = null
  description = "Enable tunnel lifecycle control for tunnel 1."
}

variable "tunnel2_enable_tunnel_lifecycle_control" {
  type        = bool
  default     = null
  description = "Enable tunnel lifecycle control for tunnel 2."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to VPN resources."
}

variable "validate_gateway_inputs" {
  type        = bool
  default     = true
  description = "Whether to validate gateway inputs."

  validation {
    condition = (
      !var.validate_gateway_inputs ||
      (
        (var.transit_gateway_id != null && var.transit_gateway_id != "") ?
        ((var.vpn_gateway_id == null || var.vpn_gateway_id == "") && var.create_vpn_gateway == false) :
        ((var.vpn_gateway_id != null && var.vpn_gateway_id != "") || var.create_vpn_gateway == true)
      )
    )
    error_message = "Provide transit_gateway_id OR vpn_gateway_id/create_vpn_gateway, but not both."
  }
}

variable "validate_vpn_gateway_vpc" {
  type        = bool
  default     = true
  description = "Whether to validate vpc_id when create_vpn_gateway is true."

  validation {
    condition     = !var.validate_vpn_gateway_vpc || !var.create_vpn_gateway || (var.vpc_id != null && var.vpc_id != "")
    error_message = "vpc_id is required when create_vpn_gateway is true."
  }
}

variable "validate_customer_gateway_inputs" {
  type        = bool
  default     = true
  description = "Whether to validate customer gateway inputs."

  validation {
    condition = (
      !var.validate_customer_gateway_inputs ||
      (var.customer_gateway_id != null && var.customer_gateway_id != "") ||
      (var.customer_gateway_ip != null && var.customer_gateway_ip != "")
    )
    error_message = "customer_gateway_ip is required when customer_gateway_id is not provided."
  }
}

variable "validate_static_routes" {
  type        = bool
  default     = true
  description = "Whether to validate static routes when static_routes_only is true."

  validation {
    condition     = !var.validate_static_routes || !var.static_routes_only || length(var.static_routes) > 0
    error_message = "static_routes must be set when static_routes_only is true."
  }
}
