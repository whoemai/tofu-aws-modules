variable "name" {
  description = "Name tag for the EBS volume"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the volume. Must match the AZ of the instance it attaches to."
  type        = string
}

variable "size" {
  description = "Size of the volume, in GiB"
  type        = number
}

variable "type" {
  description = "Volume type"
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2", "sc1", "st1", "standard"], var.type)
    error_message = "type must be one of gp2, gp3, io1, io2, sc1, st1, standard."
  }
}

variable "encrypted" {
  description = "Whether the volume is encrypted at rest"
  type        = bool
  default     = true
}

variable "iops" {
  description = "Provisioned IOPS. Required for io1/io2, optional tuning for gp3."
  type        = number
  default     = null
}

variable "throughput" {
  description = "Throughput in MiB/s. Only applies to gp3 volumes."
  type        = number
  default     = null
}

variable "kms_key_id" {
  description = "ARN of the KMS key used to encrypt the volume. Null uses the AWS-managed EBS key."
  type        = string
  default     = null
}

variable "device_name" {
  description = "Device name exposed to the instance (e.g. /dev/xvdf, /dev/sdf)"
  type        = string
}

variable "instance_id" {
  description = "ID of the EC2 instance to attach this volume to"
  type        = string
}

variable "force_detach" {
  description = "Force detach the volume on destroy, even if it's still mounted in-guest"
  type        = bool
  default     = false
}

variable "stop_instance_before_detaching" {
  description = "Stop the instance before detaching the volume, then leave it stopped"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the volume"
  type        = map(string)
  default     = {}
}
