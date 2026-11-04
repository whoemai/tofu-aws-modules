output "id" {
  description = "Cluster identifier."
  value       = aws_docdb_cluster.this.id
}

output "arn" {
  description = "ARN of the cluster."
  value       = aws_docdb_cluster.this.arn
}

output "endpoint" {
  description = "Writer (cluster) endpoint."
  value       = aws_docdb_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "Reader endpoint, load-balanced across the replicas."
  value       = aws_docdb_cluster.this.reader_endpoint
}

output "port" {
  description = "Port the cluster listens on."
  value       = aws_docdb_cluster.this.port
}

output "parameter_group_name" {
  description = "Name of the parameter group created by this module, or null when var.cluster_parameters is empty."
  value       = one(aws_docdb_cluster_parameter_group.this[*].name)
}

output "instance_identifiers" {
  description = "Instance identifiers."
  value       = aws_docdb_cluster_instance.this[*].identifier
}

output "instance_endpoints" {
  description = "Per-instance endpoints. Clients should use endpoint/reader_endpoint instead."
  value       = aws_docdb_cluster_instance.this[*].endpoint
}
