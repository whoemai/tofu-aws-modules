output "id" {
  value       = aws_eks_cluster.cluster.id
  description = "Name of the cluster."
}

output "arn" {
  value       = aws_eks_cluster.cluster.arn
  description = "ARN of the cluster."
}

output "name" {
  value       = aws_eks_cluster.cluster.name
  description = "Name of the cluster."
}

output "endpoint" {
  value       = aws_eks_cluster.cluster.endpoint
  description = "Endpoint for the Kubernetes API server."
}

output "version" {
  value       = aws_eks_cluster.cluster.version
  description = "Kubernetes version of the cluster."
}

output "status" {
  value       = aws_eks_cluster.cluster.status
  description = "Status of the EKS cluster."
}

output "certificate_authority_data" {
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
  description = "Base64 encoded certificate data required to communicate with the cluster."
}

output "oidc_issuer_url" {
  value       = try(aws_eks_cluster.cluster.identity[0].oidc[0].issuer, null)
  description = "Issuer URL for the OpenID Connect identity provider, used to set up IAM Roles for Service Accounts (IRSA)."
}

output "cluster_security_group_id" {
  value       = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  description = "Cluster security group created by Amazon EKS for the cluster."
}

output "vpc_id" {
  value       = aws_eks_cluster.cluster.vpc_config[0].vpc_id
  description = "ID of the VPC associated with the cluster."
}

output "platform_version" {
  value       = aws_eks_cluster.cluster.platform_version
  description = "Platform version for the cluster."
}
