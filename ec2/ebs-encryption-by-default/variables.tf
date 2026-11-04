variable "enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether EBS encryption by default is enabled for new volumes and snapshot copies created in this region. Uses the AWS managed key (aws/ebs) unless the account's default KMS key is changed elsewhere."
}
