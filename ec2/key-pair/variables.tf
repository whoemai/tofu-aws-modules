variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "public_key" {
  description = "Public key material (OpenSSH format, e.g. the contents of a .pub file). Only the public half is ever passed here — the private key never touches the module or state."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the key pair"
  type        = map(string)
  default     = {}
}
