# Hosted zone pública de um subdomínio delegado. A zona-mãe fica em outra conta e NÃO é
# gerenciada aqui — depois do apply, criar os registros NS lá com os valores de `name_servers`.
resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = merge(var.tags, { Name = var.domain_name })
}

# Certificado ACM (DNS-validated) pro CloudFront, que exige o cert em us-east-1. O provider
# default serve enquanto o stack rodar em us-east-1; fora disso, precisa de provider aliased.
resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = concat(["*.${var.domain_name}"], var.subject_alternative_names)
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, { Name = var.domain_name })
}

# Chave = resource_record_name pra deduplicar apex + wildcard, que a ACM valida com o MESMO
# registro CNAME.
#
# CHICKEN-AND-EGG no bootstrap: sem o cert no state, `domain_validation_options` vem toda
# "known after apply" e o for_each trava com "Invalid for_each argument". Aplicar o cert
# isolado (`-target`) antes do apply cheio resolve.
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.resource_record_name => {
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }...
  }

  zone_id         = aws_route53_zone.this.zone_id
  name            = each.key
  type            = each.value[0].type
  records         = [each.value[0].record]
  ttl             = 60
  allow_overwrite = true
}

# Espera a emissão do cert (só quando wait_for_validation = true).
resource "aws_acm_certificate_validation" "this" {
  count = var.wait_for_validation ? 1 : 0

  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}
