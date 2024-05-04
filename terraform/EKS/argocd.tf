locals {
  argo_domain_name = "argocd.${var.project}.${var.zone_name}"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  create_namespace = length(var.argocd_namespace) > 0 ? true : false
  namespace = kubernetes_namespace.argocd.metadata.0.name
  version = var.argocd_helmchart_version == "" ? null : var.argocd_helmchart_version

  values = [
    templatefile(
      "${path.module}/templates/values.yaml.tpl",
      {
        "argocd_server_host" = local.argo_domain_name,
        "eks_iam_argocd_role_arn" = aws_iam_role.cluster.arn
        "argocd_github_client_id" = var.argocd_github_client_id
        "argocd_github_client_secret" =  var.argocd_github_client_secret
        "argocd_github_org_name" = var.argocd_github_org_name
      }
    )
  ]
}