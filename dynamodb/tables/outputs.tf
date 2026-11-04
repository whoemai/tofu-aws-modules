output "table_names" {
  description = "Nomes das tabelas criadas"
  value       = sort(keys(aws_dynamodb_table.this))
}

output "table_arns" {
  description = "ARNs por nome — input das policies IRSA por app (iam/irsa-app)"
  value       = { for k, v in aws_dynamodb_table.this : k => v.arn }
}
