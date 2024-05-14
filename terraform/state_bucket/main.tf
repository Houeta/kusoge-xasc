locals {
  prefix = "${var.username}-${var.project}-tfstate"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${local.prefix}-bucket"
  tags = merge(var.tags, {
    "Created by" = "Terraform"
    "Project"    = var.project
    "Owner"      = var.username
  })
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${local.prefix}-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
