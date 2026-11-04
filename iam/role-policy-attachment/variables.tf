variable "role_name" {
  type        = string
  description = "(Required) Name of the IAM role to attach the policies to."
}

variable "policy_arns" {
  type        = list(string)
  description = "(Required) ARNs of the IAM policies (customer managed or AWS managed) to attach to the role."
}
