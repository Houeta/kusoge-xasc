locals {
  aws_addons = {
    enable_aws_ebs_csi_driver = try(var.addons.enable_aws_ebs_csi_driver, false)
    enable_aws_for_fluentbit = try(var.addons.enable_aws_for_fluentbit, false)
    enable_aws_load_balancer_controller = try(var.addons.enable_aws_load_balancer_controller, false)
    enable_cluster_autoscaler = try(var.addons.enable_cluster_autoscaler, false)
    enable_external_dns = try(var.addons.enable_external_dns, false)
    enable_metrics_server = try(var.addons.enable_metrics_server, false)
    enable_argocd = try(var.addons.enable_argocd, false)
    enable_argo_rollouts = try(var.addons.enable_argo_rollouts, false)
    enable_argo_events = try(var.addons.enable_argo_events, false)
    enable_argo_workflows = try(var.addons.enable_argo_workflows, false)
    enable_ingress_nginx = try(var.addons.enable_ingress_nginx, false)
  }

  oss_addons = {
    enable_argocd                          = try(var.addons.enable_argocd, true)
    enable_argo_rollouts                   = try(var.addons.enable_argo_rollouts, false)
    enable_argo_events                     = try(var.addons.enable_argo_events, false)
    enable_argo_workflows                  = try(var.addons.enable_argo_workflows, false)
    enable_cluster_proportional_autoscaler = try(var.addons.enable_cluster_proportional_autoscaler, false)
    enable_gatekeeper                      = try(var.addons.enable_gatekeeper, false)
    enable_gpu_operator                    = try(var.addons.enable_gpu_operator, false)
    enable_ingress_nginx                   = try(var.addons.enable_ingress_nginx, false)
    enable_kyverno                         = try(var.addons.enable_kyverno, false)
    enable_kube_prometheus_stack           = try(var.addons.enable_kube_prometheus_stack, false)
    enable_metrics_server                  = try(var.addons.enable_metrics_server, false)
    enable_prometheus_adapter              = try(var.addons.enable_prometheus_adapter, false)
    enable_secrets_store_csi_driver        = try(var.addons.enable_secrets_store_csi_driver, false)
    enable_vpa                             = try(var.addons.enable_vpa, false)
  }

  addons = merge(
    local.aws_addons,
    local.oss_addons,
    { kubernetes_version = local.cluster_version },
    { aws_cluster_name = module.eks.cluster_name }
  )
  
  metadata_addons = merge(
    module.eks_addons.gitops_metadata,
    {
      aws_cluster_name = module.eks.cluster_name
      aws_region = var.region
      aws_account_id = data.aws_caller_identity.this.account_id
      aws_vpc_id = module.vpc.vpc_id
    },
    {
      external_dns_domain_filters = var.hosted_zone_name
    },
    {
      addons_repo_url = local.gitops_addons_url
      addons_repo_basepath = local.gitops_addons_basepath
      addons_repo_path = local.gitops_addons_path
      addons_repo_revision = local.gitops_addons_revision
    },
    {
      workload_repo_url = "https://github.com/Houeta/kusoge-app"
      workload_repo_revision = "main"
    }
  )
}

#Bridge: Bootstrap
module "gitops_bridge_bootstrap" {
  source = "gitops-bridge-dev/gitops-bridge/helm"

  cluster = {
    cluster_name = module.eks.cluster_name
    environment = var.env
    metadata = local.metadata_addons
    addons = local.addons
  }
}

module "eks_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_version = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  create_kubernetes_resources = false

  external_dns_route53_zone_arns = [data.aws_route53_zone.domain.arn]

  # enable_aws_efs_csi_driver = local.aws_addons.enable_aws_ebs_csi_driver
  enable_aws_load_balancer_controller = local.aws_addons.enable_aws_load_balancer_controller
  enable_aws_for_fluentbit = local.aws_addons.enable_aws_for_fluentbit
  enable_cluster_autoscaler = local.aws_addons.enable_cluster_autoscaler
  enable_metrics_server = local.aws_addons.enable_metrics_server
  enable_external_dns = local.aws_addons.enable_external_dns
  

  tags = local.aws_tags
}