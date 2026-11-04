output "id" {
  value       = aws_eks_addon.addon.id
  description = "EKS Cluster name and EKS Addon name separated by a colon."
}

output "arn" {
  value       = aws_eks_addon.addon.arn
  description = "ARN of the EKS add-on."
}

output "created_at" {
  value       = aws_eks_addon.addon.created_at
  description = "Date and time in RFC3339 format that the add-on was created."
}

output "modified_at" {
  value       = aws_eks_addon.addon.modified_at
  description = "Date and time in RFC3339 format that the add-on was last modified."
}
