output "access_entry_arn" {
  value       = aws_eks_access_entry.access_entry.access_entry_arn
  description = "ARN of the Access Entry."
}

output "principal_arn" {
  value       = aws_eks_access_entry.access_entry.principal_arn
  description = "IAM Principal ARN associated with the Access Entry."
}
