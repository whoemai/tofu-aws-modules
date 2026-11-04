output "fqdn" {
  description = "The full name of the created record, including the trailing zone."
  value       = aws_route53_record.this.fqdn
}

output "name" {
  description = "The name of the record as stored by Route53."
  value       = aws_route53_record.this.name
}
