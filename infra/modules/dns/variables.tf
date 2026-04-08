variable "domain_name" {
  description = "The domain name for the hosted zone and certificate"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution (for A record alias)"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution (for A record alias)"
  type        = string
}
