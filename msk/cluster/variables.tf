variable "cluster_name" {
  type        = string
  description = "(Required) Name of the MSK cluster."
}

variable "kafka_version" {
  type        = string
  description = "(Required) Version of Kafka run by the brokers. Changing this is an in-place upgrade via the MSK API, not a replace."
}

variable "instance_type" {
  type        = string
  description = "(Required) Instance type for the brokers. Changing this is an in-place resize (UpdateBrokerType), not a replace."
}

variable "number_of_broker_nodes" {
  type        = number
  description = "(Required) Total number of brokers. Must be a multiple of length(var.client_subnets). Can be increased in-place; cannot be decreased."
}

variable "ebs_volume_size" {
  type        = number
  description = "(Required) EBS volume size (GiB) per broker. Changing this is an in-place resize (UpdateBrokerStorage)."
}

variable "client_subnets" {
  type        = list(string)
  description = "(Required) Private subnets for the brokers, one per AZ. length() must evenly divide number_of_broker_nodes. Changing this list forces recreation of the whole cluster."
}

variable "security_group_ids" {
  type        = list(string)
  description = "(Required) Security groups attached to the broker ENIs — created outside this module (see vpc/security-group)."
}

variable "kms_key_arn" {
  type        = string
  description = "(Required) KMS key ARN for encryption at rest. Changing this forces recreation of the whole cluster — encryption_info is immutable in the MSK API."
}

variable "client_broker_encryption" {
  type        = string
  description = "(Required) TLS_PLAINTEXT | TLS | PLAINTEXT. TLS_PLAINTEXT exposes both the plaintext and TLS listeners at once. Changing this forces recreation of the whole cluster."
}

variable "encryption_in_cluster" {
  type        = bool
  description = "(Required) Broker-to-broker (inter-AZ replication) encryption. Changing this forces recreation of the whole cluster."
}

variable "sasl_iam_enabled" {
  type        = bool
  description = "(Required) Enable SASL/IAM authentication (port 9098). Safe to change in-place."
}

variable "unauthenticated_enabled" {
  type        = bool
  description = "(Required) Allow unauthenticated connections on the plaintext (9092) and TLS (9094) listeners. Safe to change in-place."
}

variable "enhanced_monitoring" {
  type        = string
  description = "(Required) DEFAULT | PER_BROKER | PER_TOPIC_PER_BROKER."
}

variable "server_properties" {
  type        = map(string)
  default     = {}
  description = "(Optional) Broker server.properties overrides (e.g. { \"auto.create.topics.enable\" = \"true\" }). Empty = MSK's default configuration, no aws_msk_configuration created. Changing it creates a new configuration revision and rolls every broker in-place."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The Tags to resource"
}
