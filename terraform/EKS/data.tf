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
