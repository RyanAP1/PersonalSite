terraform {

  cloud {
      organization = "RyanAPLearning"
      workspaces {
          name = "PersonalSiteProd"
      }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  required_version = ">= 1.1.9"
}

#Current Settings are remote execution on Terraform Cloud

# Setting privoder information for the run
provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "www" {
  # Name of bucket, when used for site with dns entry, same as domain name
  bucket = "${var.site_name_prod}"

  # Needs to be available on the internet
  acl = "private"

  #Allows the bucket to be deleted even if it has content
  force_destroy = true

  # Policy for veiwing content. Required by aws
  policy = data.aws_iam_policy_document.website_policy.json

  #S3 settings for hosting websites
  website {
    #What to resolve requests incoming to root
    index_document = "index.html"

    #What to serve is request results in error or non-existing page.
    error_document = "404.html"
  }
}

#policy document for S3 bucket
data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
      type = "AWS"
    }
    resources = ["arn:aws:s3:::${aws_s3_bucket.www.bucket}/*"]
  }

  statement {
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.www.bucket}"]
    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

# ROUTE53 Section

resource "aws_route53_zone" "primary" {
  name = "${var.site_name_prod}"

}

resource "aws_route53_record" "a-record" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name = "${var.site_name_prod}"
  type = "A"
  alias {
    name = "${aws_cloudfront_distribution.prod_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.prod_distribution/hosted_zone_id}"
    evaluate_target_health = false
  }
}

# For AWS, we can do DNS validation through Route 53 for ACM
resource "aws_route53_record" "cert_validation" {
  count = length(aws_acm_certificate.cert.domain_validation_options)
  name = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_name, count.index)
  type = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_type, count.index)
  zone_id = aws_route53_zone.primary.zone_id
  records = [element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_value, count.index)]
  ttl = 60
}


# ACM Certificate Section

resource "aws_acm_certificate" "cert" {
  domain_name = "${var.site_name_prod}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

# Cloudfront CDN Section

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {}

resource "aws_cloudfront_distribution" "prod_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.www.bucket_regional_domain_name}"
    origin_id = "S3-${aws_s3_bucket.www.bucket}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  #index.html as root object
  default_root_object = "index.html"
  enabled = true
  is_ipv6_enabled = true
  aliases = [var.site_name_prod]

  #For 404, return 404 page with HTTP 200 Response
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code = 404
    response_code = 200
    response_page_path = "/404.html"
  }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.www.bucket}"

    #Forward query strings, cookies and headers
    forwarded_values {
      query_string = true
        cookies {
          forward = "none"
        }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  #Price class for US and Europe
  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  #SSL certificate for the service
  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
    ssl_support_method = "sni-only"
  }
}