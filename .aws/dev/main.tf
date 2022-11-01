terraform {

  cloud {
      organization = "RyanAPLearning"
      workspaces {
          name = "PersonalSite"
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
  bucket = "${var.site_name_dev}"

  # Needs to be available on the internet
  acl = "public-read"

  #Allows the bucket to be deleted even if it has content
  force_destroy = true

  # Policy for veiwing content. Required by aws
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.site_name_dev}/*"]
    }
  ]
}
  POLICY

  #S3 settings for hosting websites
  website {
    #What to resolve requests incoming to root
    index_document = "index.html"

    #What to serve is request results in error or non-existing page.
    error_document = "404.html"
  }
}

#Bucket for www-redirect
resource "aws_s3_bucket" "website_redirect" {
  bucket = "www.${var.site_name_dev}"
  acl = "public-read"

  website {
    redirect_all_requests_to = "${aws_s3_bucket.www.website_endpoint}"
  }

  # Policy for veiwing content. Required by aws
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::www.${var.site_name_dev}/*"]
    }
  ]
}
  POLICY
}