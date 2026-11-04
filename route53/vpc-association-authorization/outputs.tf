output "zone_id" {
  description = "The ID of the hosted zone the authorization was created for."
  value       = aws_route53_vpc_association_authorization.this.zone_id
}

output "vpc_id" {
  description = "The ID of the VPC the authorization was created for."
  value       = aws_route53_vpc_association_authorization.this.vpc_id
}
