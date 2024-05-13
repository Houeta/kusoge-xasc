data "aws_route53_zone" "zone" {
  name         = var.zone_name
  private_zone = false
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

data "aws_caller_identity" "account" {}