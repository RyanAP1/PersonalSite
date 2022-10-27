variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "site_name_dev" {
  description = "DNS name of the site that is being created. For Dev"
}

variable "site_name_prod" {
  description = "DNS name of the site that is being created. For Prod"
}