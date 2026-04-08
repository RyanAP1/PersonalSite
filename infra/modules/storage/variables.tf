variable "bucket_name" {
  description = "Name of the S3 bucket (typically the domain name)"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even with content"
  type        = bool
  default     = true
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution allowed to access this bucket"
  type        = string
}
