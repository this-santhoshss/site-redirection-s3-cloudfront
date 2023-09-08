terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3"
    }
  }

  required_version = "~> 1.5"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.region
  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"
   profile = var.aws_profile
   default_tags {
    tags = local.default_tags
  }
}