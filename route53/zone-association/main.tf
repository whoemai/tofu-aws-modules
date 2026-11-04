# Lado 2 do handshake cross-account (ver route53/vpc-association-authorization
# pro lado 1) — chamado pela conta DONA DA VPC, de fato associando a VPC à
# zone. Só funciona depois que a autorização do lado 1 já existir; sem ela,
# a AWS retorna AccessDenied (achado real do provider AWS, comentado no
# próprio código-fonte do recurso).
resource "aws_route53_zone_association" "this" {
  zone_id    = var.zone_id
  vpc_id     = var.vpc_id
  vpc_region = var.vpc_region
}
