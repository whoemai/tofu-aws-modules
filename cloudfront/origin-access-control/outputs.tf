output "id" {
  description = "ID do OAC — input `origin_access_control_id` da origem no módulo cloudfront/distribution."
  value       = aws_cloudfront_origin_access_control.this.id
}

output "etag" {
  description = "Versão atual do OAC, exigida pela API em update/delete fora do Terraform."
  value       = aws_cloudfront_origin_access_control.this.etag
}
