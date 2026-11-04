output "fqdn" {
  description = "FQDN do registro criado — é o hostname que entra no .properties do app"
  value       = aws_route53_record.this.fqdn
}
