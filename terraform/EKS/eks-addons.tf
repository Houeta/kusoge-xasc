module "eks-external-dns" {
  source                           = "lablabs/eks-external-dns/aws"
  version                          = "1.2.0"
  cluster_identity_oidc_issuer     = aws_eks_cluster.this.identity.0.oidc.0.issuer
  cluster_identity_oidc_issuer_arn = module.oidc-provider-data.arn
  irsa_role_name_prefix            = "${local.global_prefix}-external-dns"
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "coredns"
  addon_version               = "v1.11.1-eksbuild.4"
  resolve_conflicts_on_create = "OVERWRITE"
  depends_on                  = [aws_eks_node_group.amd]
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.30.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = module.ebs_csi_irsa_role.iam_role_arn
}

resource "helm_release" "metrics" {
  depends_on       = [aws_eks_node_group.amd]
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server"
  chart            = "metrics-server"
  version          = "3.12.1"
  namespace        = "kube-system"
  create_namespace = true
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "kube-system"
  version    = "0.9.18"

  set {
    name  = "certController.serviceAccount.name"
    value = local.external_secrets.service_account_name
  }

  set {
    name = "certController.serviceAccount\\.annotations"
    value = yamlencode({
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_external_secrets.iam_role_arn
    })
  }
}

# module "external_secrets" {
#   source = "git::https://github.com/DNXLabs/terraform-aws-eks-external-secrets.git?ref=0.1.4"

#   enabled = true

#   cluster_name                     = aws_eks_cluster.this.name
#   cluster_identity_oidc_issuer     = replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
#   cluster_identity_oidc_issuer_arn = module.oidc-provider-data.arn
#   secrets_aws_region               = var.region

# }
