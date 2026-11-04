output "id" {
  value       = aws_eks_fargate_profile.fargate_profile.id
  description = "EKS Cluster name and EKS Fargate Profile name separated by a colon."
}

output "arn" {
  value       = aws_eks_fargate_profile.fargate_profile.arn
  description = "ARN of the EKS Fargate Profile."
}

output "status" {
  value       = aws_eks_fargate_profile.fargate_profile.status
  description = "Status of the EKS Fargate Profile."
}
