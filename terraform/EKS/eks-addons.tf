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

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.this.name
  addon_name = "aws-ebs-csi-driver"
  addon_version = "v1.30.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
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
  name = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart = "external-secrets"
  namespace = "kube-system"
  version = "0.5.0"
}

# module "eks_blueprints_addons" {
#   source = "aws-ia/eks-blueprints-addons/aws"
#   version = "~> 1.16" #ensure to update this to the latest/desired version

#   cluster_name      = aws_eks_cluster.this.name
#   cluster_endpoint  = aws_eks_cluster.this.endpoint
#   cluster_version   = aws_eks_cluster.this.version
#   oidc_provider_arn = aws_eks_cluster.this.role_arn

#   eks_addons = {
#     aws-ebs-csi-driver = {
#       most_recent = true
#     }
#     coredns = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#   }

#   enable_aws_load_balancer_controller    = true
#   enable_cluster_proportional_autoscaler = true
#   enable_karpenter                       = true
#   enable_kube_prometheus_stack           = true
#   enable_metrics_server                  = true
#   enable_external_dns                    = true
#   enable_cert_manager                    = true
#   cert_manager_route53_hosted_zone_arns  = ["arn:aws:route53:::hostedzone/XXXXXXXXXXXXX"]

#   tags = {
#     Environment = "dev"
#   }
# }

