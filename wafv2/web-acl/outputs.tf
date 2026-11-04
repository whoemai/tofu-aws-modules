output "arn" {
  description = "ARN da WebACL — é o que a distribuição CloudFront (`web_acl_id`) e o `aws_wafv2_web_acl_association` esperam."
  value       = aws_wafv2_web_acl.this.arn
}

output "id" {
  description = "ID da WebACL. Necessário junto do nome e do scope pra importar o recurso."
  value       = aws_wafv2_web_acl.this.id
}

output "capacity" {
  description = "WCU consumida pelas rules. O teto default por WebACL é 1500 WCU (aumentável por ticket) — passar disso reprova o apply."
  value       = aws_wafv2_web_acl.this.capacity
}
