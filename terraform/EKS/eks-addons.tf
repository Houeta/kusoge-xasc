module "eks-external-dns" {
  source                           = "lablabs/eks-external-dns/aws"
  version                          = "1.2.0"
  cluster_identity_oidc_issuer     = aws_eks_cluster.this.identity.0.oidc.0.issuer
  cluster_identity_oidc_issuer_arn = module.oidc-provider-data.arn
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "coredns"
  addon_version               = "v1.11.1-eksbuild.4"
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [aws_eks_node_group.amd]
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

