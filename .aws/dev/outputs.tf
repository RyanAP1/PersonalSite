output "region" {
  description = "AWS region"
  value       = var.region
}

output "s3_website_endpoint" {
  value = "${aws_s3_bucket.www.website_endpoint}"
}