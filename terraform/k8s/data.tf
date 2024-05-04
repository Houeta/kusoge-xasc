data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

data "aws_route53_zone" "domain" {
  name = var.hosted_zone_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "this" {}
data "aws_availability_zones" "azs" {}