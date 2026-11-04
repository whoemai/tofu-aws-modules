output "cluster_arn" {
  description = "ARN of the MSK cluster."
  value       = aws_msk_cluster.this.arn
}

output "bootstrap_brokers" {
  description = "Plaintext bootstrap brokers (port 9092)."
  value       = aws_msk_cluster.this.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "TLS bootstrap brokers (port 9094)."
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "bootstrap_brokers_sasl_iam" {
  description = "SASL/IAM bootstrap brokers (port 9098)."
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "zookeeper_connect_string" {
  description = "MSK's internal Zookeeper connect string. For troubleshooting only — no client should use this directly."
  value       = aws_msk_cluster.this.zookeeper_connect_string
}

output "configuration_arn" {
  description = "ARN of the attached MSK configuration, or null when var.server_properties is empty."
  value       = one(aws_msk_configuration.this[*].arn)
}
