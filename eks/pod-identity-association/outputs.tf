output "association_arn" {
  value       = aws_eks_pod_identity_association.association.association_arn
  description = "ARN of the association."
}

output "association_id" {
  value       = aws_eks_pod_identity_association.association.association_id
  description = "ID of the association."
}

output "external_id" {
  value       = aws_eks_pod_identity_association.association.external_id
  description = "Unique identifier for this association used in the target role's trust policy Condition to match sts:ExternalId."
}
