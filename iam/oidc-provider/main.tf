data "tls_certificate" "issuer" {
  url = var.url
}

resource "aws_iam_openid_connect_provider" "this" {
  url            = var.url
  client_id_list = var.client_id_list

  thumbprint_list = (
    var.thumbprint_list != null
    ? var.thumbprint_list
    : [data.tls_certificate.issuer.certificates[0].sha1_fingerprint]
  )

  tags = var.tags
}
