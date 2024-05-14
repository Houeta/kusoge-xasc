terraform {
  backend "s3" {
    region         = "eu-central-1"
    profile        = "mfa"
    bucket         = "miracle-kusoge-tfstate-bucket"
    key            = "miracle-eks/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "miracle-kusoge-tfstate-lock"
  }
}

