terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">=1.7"
  
  backend "s3" {
    region = "eu-central-1"
    profile = "mfa"
    bucket         = "miracle-kusoge-tfstate-bucket"
    key            = "miracle/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "miracle-kusoge-tfstate-lock"
  }
}