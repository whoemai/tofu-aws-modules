output "id" {
  description = "ID do SG — é o que `vpc_security_group_ids`/`security_group_ids` dos recursos esperam."
  value       = aws_security_group.this.id
}

output "arn" {
  description = "ARN do SG."
  value       = aws_security_group.this.arn
}

output "name" {
  description = "Nome real do SG, já com o sufixo que o `name_prefix` gerou."
  value       = aws_security_group.this.name
}
