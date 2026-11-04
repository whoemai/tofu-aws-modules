variable "name" {
  description = "Name of the launch template."
  type        = string
}

variable "instance_tags" {
  description = "Tags applied to EC2 instances launched from this template (tag_specifications resource_type = \"instance\")."
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "Tags applied to EBS volumes launched from this template (tag_specifications resource_type = \"volume\")."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to the launch template resource itself."
  type        = map(string)
  default     = {}
}

variable "image_id" {
  description = "(Optional) AMI ID to launch. Null pra deixar de fora do template (uso EKS Managed Node Group)."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "(Optional) Instance type. Null pra deixar de fora do template (uso EKS Managed Node Group)."
  type        = string
  default     = null
}

variable "key_name" {
  description = "(Optional) Key pair name."
  type        = string
  default     = null
}

variable "user_data" {
  description = "(Optional) User data em texto puro — o módulo faz o base64encode (aws_launch_template exige já encodado, diferente de aws_launch_configuration/aws_instance)."
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "(Optional) Security group IDs. Vazio pra deixar de fora do template."
  type        = list(string)
  default     = []
}

variable "iam_instance_profile_arn" {
  description = "(Optional) ARN do instance profile IAM. Null pra deixar de fora do template."
  type        = string
  default     = null
}

variable "network_interface_tags" {
  description = "Tags applied to ENIs launched from this template (tag_specifications resource_type = \"network-interface\")."
  type        = map(string)
  default     = {}
}

variable "block_device_mappings" {
  description = "(Optional) Block device mappings (ex.: volume raiz gp3 com tamanho customizado). Lista vazia deixa de fora do template."
  type = list(object({
    device_name = string
    ebs = optional(object({
      volume_size           = optional(number)
      volume_type           = optional(string)
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
      kms_key_id            = optional(string)
      iops                  = optional(number)
      throughput            = optional(number)
      snapshot_id           = optional(string)
    }))
  }))
  default = []
}

variable "metadata_options" {
  description = "(Optional) Opções de IMDS (ex.: exigir IMDSv2 com http_tokens = \"required\"). Null deixa de fora do template (default AWS: IMDSv1+v2 liberados)."
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
    instance_metadata_tags      = optional(string)
  })
  default = null
}
