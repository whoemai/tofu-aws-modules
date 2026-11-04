variable "name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "AMI ID to use for the instance. If null, ami_filters will be used"
  type        = string
  default     = null
}

variable "ami_filters" {
  description = "Filters to select AMI. Used only if ami is null"
  type = object({
    owners = list(string)
    filters = list(object({
      name   = string
      values = list(any)
    }))
  })
  default = null
}

variable "vpc_id" {
  description = "VPC ID where the instance will be created"
  type        = string
}

variable "subnet_id" {
  description = "List of subnet IDs where the instance can be created"
  type        = list(string)
}

variable "allow_ssh_from_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH into the instance"
  type        = list(string)
  default     = []
}

variable "allow_ssh_from_security_group_ids" {
  description = "List of security group IDs allowed to SSH into the instance"
  type        = list(string)
  default     = []
}

variable "allow_port_from_cidr_blocks" {
  description = "Map of port rules from CIDR blocks"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "allow_port_from_security_group_ids" {
  description = "Map of port rules from security group IDs"
  type = map(object({
    from_port          = number
    to_port            = number
    protocol           = string
    security_group_ids = list(string)
  }))
  default = {}
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for DNS record"
  type        = string
  default     = ""
}

variable "route53_lookup_domain_name" {
  description = "Domain name for Route53 lookup"
  type        = string
  default     = ""
}

variable "dns_zone_is_private" {
  description = "Whether the Route53 zone is private"
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 30
}

variable "ebs_volumes" {
  description = "Map of additional EBS volumes to attach"
  type = map(object({
    device_name = string
    size        = number
    type        = string
    encrypted   = optional(bool, true)
    iops        = optional(number)
    throughput  = optional(number)
  }))
  default = {}
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the instance, alongside the one this module creates."
  type        = list(string)
  default     = []
}

variable "iam_policy_arns" {
  description = "Additional AWS managed or customer managed policy ARNs to attach to the IAM role this module creates. Ignored when iam_instance_profile_name is set."
  type        = list(string)
  default     = []
}

variable "iam_instance_profile_name" {
  description = "Name of an existing IAM instance profile to attach to the instance instead of the one this module creates. When set, this module does not create its own IAM role/instance profile, and iam_policy_arns is ignored — the caller owns that role's policies."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance. Left null, it defers to the subnet's auto-assign-public-IP setting."
  type        = bool
  default     = null
}

variable "key_name" {
  description = "Name of an existing EC2 key pair to attach to the instance. Left null, no key pair is attached (prefer SSM Session Manager)."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script passed to the instance at launch (plain text; the provider base64-encodes it). Do not embed secrets here — it is readable via ec2:DescribeInstanceAttribute and stored in state."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Whether a change to user_data replaces the instance (true) or updates it in place with a stop/start (false). Maps 1:1 to aws_instance.user_data_replace_on_change."
  type        = bool
  default     = false
}

variable "metadata_options" {
  description = "Instance Metadata Service options, mapped 1:1 to the aws_instance metadata_options block (e.g. http_tokens = \"required\" for IMDSv2-only). Left null, the block is omitted and AWS/account defaults apply."
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
    instance_metadata_tags      = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
