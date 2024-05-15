locals {
  azs = slice(data.aws_availability_zones.azs.names, 0, 3)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  putin_khuylo = true
  name         = "${local.global_prefix}-vpc"
  cidr         = var.vpc_cidr
  azs          = local.azs

  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    elb = "external"
  }

  private_subnet_tags = {
    elb = "internal"
  }

  default_security_group_name = "${local.global_prefix}-vpc-sg"

  tags = local.aws_tags
}