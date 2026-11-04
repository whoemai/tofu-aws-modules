variable "tg_name" {
  description = "Name of the Target Group"
  type        = string
}

variable "tg_port" {
  description = "Port for the Target Group (must match ECS container port)"
  type        = number
}

variable "tg_protocol" {
  description = "Protocol for the Target Group"
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["GENEVE", "HTTP", "HTTPS", "TCP", "TCP_UDP", "TLS", "UDP", "QUIC", "TCP_QUIC"], upper(var.tg_protocol))
    error_message = "tg_protocol must be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, UDP, QUIC, or TCP_QUIC."
  }
}

variable "health_check_protocol" {
  description = "Protocol for the health check. Defaults to tg_protocol when null. AWS does not support TCP health checks when tg_protocol is HTTP or HTTPS."
  type        = string
  default     = null

  validation {
    condition     = var.health_check_protocol == null || contains(["TCP", "HTTP", "HTTPS"], upper(var.health_check_protocol))
    error_message = "health_check_protocol must be null, TCP, HTTP, or HTTPS."
  }

  validation {
    condition = (
      var.health_check_protocol == null ||
      upper(var.health_check_protocol) != "TCP" ||
      !contains(["HTTP", "HTTPS"], upper(var.tg_protocol))
    )
    error_message = "health_check_protocol cannot be TCP when tg_protocol is HTTP or HTTPS."
  }
}

variable "tg_target_type" {
  description = "Target type for the Target Group (instance or ip)"
  type        = string
  default     = "ip"

  validation {
    condition     = contains(["instance", "ip"], lower(var.tg_target_type))
    error_message = "tg_target_type must be either 'instance' or 'ip'. For Fargate, use 'ip'."
  }
}

variable "vpc_id" {
  description = "VPC ID where the Target Group will be created"
  type        = string
}

# Health check configuration
variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "HTTP codes to match for health check"
  type        = string
  default     = "200-399"
}

variable "health_check_interval" {
  description = "Interval between health checks (seconds)"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout for health check (seconds)"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful checks before target is healthy"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed checks before target is unhealthy"
  type        = number
  default     = 2
}

variable "health_check_port" {
  description = "Port for health check. Use 'traffic-port' to use the port of the target group."
  type        = string
  default     = "traffic-port"
}

variable "tags" {
  description = "Tags to apply to the Target Group"
  type        = map(string)
  default     = {}
}