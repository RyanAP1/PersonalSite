output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.storage.bucket_id
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cdn.distribution_id
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = module.cdn.distribution_domain_name
}

output "site_url" {
  description = "The live site URL"
  value       = "https://${var.domain_name}"
}

output "name_servers" {
  description = "Name servers for the Route53 hosted zone"
  value       = module.dns.name_servers
}
