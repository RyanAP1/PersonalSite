output "zone_id" {
  description = "The Route53 hosted zone ID"
  value       = aws_route53_zone.site.zone_id
}

output "certificate_arn" {
  description = "The ARN of the validated ACM certificate"
  value       = aws_acm_certificate.site.arn
}

output "name_servers" {
  description = "The name servers for the hosted zone"
  value       = aws_route53_zone.site.name_servers
}
