# O OAC sozinho não dá acesso a nada: ele só faz o CloudFront assinar a request pra origem.
# Quem autoriza é a policy da origem (bucket policy liberando `cloudfront.amazonaws.com` com
# `AWS:SourceArn` = ARN da distribuição). Sem essa policy a origem responde 403.
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = var.name
  description                       = var.description
  origin_access_control_origin_type = var.origin_type
  signing_behavior                  = var.signing_behavior
  signing_protocol                  = var.signing_protocol
}
