variable "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 origin bucket"
  type        = string
}

variable "bucket_id" {
  description = "ID/name of the S3 origin bucket"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name for the distribution (e.g., ryanaparedes.com)"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100" # US + Europe
}
