output "id" {
  description = "ID da policy — input `response_headers_policy_id` do behavior em cloudfront/cloudfront-distribution."
  value       = aws_cloudfront_response_headers_policy.this.id
}

output "etag" {
  description = "Versão atual da policy, exigida pela API em update/delete fora do Terraform."
  value       = aws_cloudfront_response_headers_policy.this.etag
}
