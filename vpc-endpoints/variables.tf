terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.61.0"
    }
  }
}

provider "aws" {
  region  = "ca-central-1"
  profile = "default"
  default_tags {
    tags = {
      Owner   = "AJ"
      Project = "terraform-aws"
    }
  }
}