output "enabled" {
  value       = aws_ebs_encryption_by_default.this.enabled
  description = "Whether EBS encryption by default is enabled in this region."
}
