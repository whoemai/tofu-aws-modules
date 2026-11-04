output "id" {
  value       = aws_eks_node_group.node_group.id
  description = "EKS Cluster name and EKS Node Group name separated by a colon."
}

output "arn" {
  value       = aws_eks_node_group.node_group.arn
  description = "ARN of the EKS Node Group."
}

output "node_group_name" {
  value       = aws_eks_node_group.node_group.node_group_name
  description = "Name of the EKS Node Group."
}

output "status" {
  value       = aws_eks_node_group.node_group.status
  description = "Status of the EKS Node Group."
}

output "autoscaling_group_names" {
  value       = [for group in aws_eks_node_group.node_group.resources[0].autoscaling_groups : group.name]
  description = "Names of the underlying Auto Scaling Groups."
}

output "remote_access_security_group_id" {
  value       = try(aws_eks_node_group.node_group.resources[0].remote_access_security_group_id, null)
  description = "Identifier of the remote access EC2 Security Group."
}
