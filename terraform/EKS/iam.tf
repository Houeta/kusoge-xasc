# For cluster

locals {
  cluster_role_name = "${local.global_prefix}-cluster-role"
  node_role_name = "${local.global_prefix}-node-role"
}

resource "aws_iam_role" "cluster" {
  name = "${local.global_prefix}-cluster-0"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(
    var.tags,
    { Name = "${local.global_prefix}-cluster-0" }
  )
}

resource "aws_iam_role_policy_attachment" "kubeedge-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "kubeedge-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

data "tls_certificate" "cert" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "openid_connect" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

module "oidc-provider-data" {
  source     = "reegnz/oidc-provider-data/aws"
  version    = "0.0.3"
  issuer_url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# For nodes
resource "aws_iam_role" "node" {
  name = "${local.global_prefix}-node-0"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(
    var.tags,
    { Name = "${local.global_prefix}-node-0" }
  )
}

resource "aws_iam_policy" "secrets_policy" {
  name        = "${local.global_prefix}-getSecrets"
  path        = "/"
  description = "Policy to read aws secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "AllowListHostedZones1",
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kubeedge-node-AmazonSecretsPolicy" {
  policy_arn = aws_iam_policy.secrets_policy.arn
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "kubeedge-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "kubeedge-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "kubeedge-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}