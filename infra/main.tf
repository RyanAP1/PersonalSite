provider "aws" {
  region = var.region
}

# --- DNS & Certificate (must be created first) ---
module "dns" {
  source = "./modules/dns"

  domain_name               = var.domain_name
  cloudfront_domain_name    = module.cdn.distribution_domain_name
  cloudfront_hosted_zone_id = module.cdn.distribution_hosted_zone_id
}

# --- CloudFront CDN ---
module "cdn" {
  source = "./modules/cdn"

  bucket_regional_domain_name = module.storage.bucket_regional_domain_name
  bucket_id                   = module.storage.bucket_id
  domain_name                 = var.domain_name
  acm_certificate_arn         = module.dns.certificate_arn
}

# --- S3 Storage ---
module "storage" {
  source = "./modules/storage"

  bucket_name                 = var.domain_name
  cloudfront_distribution_arn = module.cdn.distribution_arn
}
