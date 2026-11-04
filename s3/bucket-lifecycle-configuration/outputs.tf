
output "bucket" {
  description = "Bucket whose lifecycle configuration is managed."
  value       = aws_s3_bucket_lifecycle_configuration.this.bucket
}

output "rule_ids" {
  description = "IDs of the lifecycle rules applied."
  value       = [for r in var.rules : r.id]
}
