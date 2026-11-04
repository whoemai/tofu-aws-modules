output "associated_at" {
  value       = aws_eks_access_policy_association.association.associated_at
  description = "Date and time that the policy was associated."
}

output "modified_at" {
  value       = aws_eks_access_policy_association.association.modified_at
  description = "Date and time that the policy association was last updated."
}
