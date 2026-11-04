output "arn" {
  value = aws_route53_zone.zone.arn
}

output "zone_id" {
  value = aws_route53_zone.zone.zone_id
}

output "name_servers" {
  value = aws_route53_zone.zone.name_servers
}

output "primary_name_server" {
  value = aws_route53_zone.zone.primary_name_server
}

output "tags_all" {
  value = aws_route53_zone.zone.tags_all
}
