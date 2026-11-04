# Lado 1 do handshake cross-account de associação de VPC com uma Private
# Hosted Zone: chamado pela conta DONA DA ZONE, autorizando uma VPC
# específica de OUTRA conta a se associar. Não move nada sozinho — só cria
# uma permissão pendente, que a conta dona da VPC consome via
# route53/zone-association (aws_route53_zone_association).
#
# zone_id é só uma referência (a zone já existe, este módulo não a cria/
# gerencia) — mesma relação de "policy referencia role pelo nome" já usada
# em iam/policy, não o acoplamento de ciclo de vida de kms/kms-alias.
resource "aws_route53_vpc_association_authorization" "this" {
  zone_id    = var.zone_id
  vpc_id     = var.vpc_id
  vpc_region = var.vpc_region
}
