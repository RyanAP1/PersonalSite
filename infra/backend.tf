terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.39"
    }
  }

  # Terraform Cloud — remote execution
  # AWS credentials are configured as workspace variables in TFC
  cloud {
    organization = "RyanAPLearning"

    workspaces {
      tags = ["personalsite"]
    }
  }
}
