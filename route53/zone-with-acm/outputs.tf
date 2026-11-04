output "zone_id" {
  description = "ID da hosted zone criada (input para registros DNS ou módulos de CloudFront)."
  value       = aws_route53_zone.this.zone_id
}

output "zone_name" {
  value = aws_route53_zone.this.name
}

output "name_servers" {
  description = "Name servers da hosted zone criada. Crie registros NS na zona-mãe com estes valores para delegar o subdomínio."
  value       = aws_route53_zone.this.name_servers
}

output "acm_certificate_arn" {
  description = "ARN do certificado ACM (us-east-1) — input `certificate_arn` para CloudFront/ALB."
  value       = var.wait_for_validation ? aws_acm_certificate_validation.this[0].certificate_arn : aws_acm_certificate.this.arn
}
