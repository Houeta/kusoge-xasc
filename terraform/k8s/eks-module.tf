##
# EKS Module
##

locals {
  cluster_name = "${local.global_prefix}-eks"
  cluster_version = var.kubernetes_version

  gitops_addons_url = "${var.gitops_addons_org}/${var.gitops_addons_repo}"
  gitops_addons_basepath = var.gitops_addons_basepath
  gitops_addons_path = var.gitops_addons_path
  gitops_addons_revision = var.gitops_addons_revision
}

# EKS Cluster

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name = "${local.global_prefix}-eks"
  cluster_version = local.cluster_version
  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = [var.instance_type]

      min_size = var.node_min_size
      max_size = var.node_max_size
      desired_size = var.node_desired_size
    }
  }

  cluster_addons = {
    vpc-cni = {
      before_compute = true
      most_recent = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET = "1"
        }
      })
    }
    aws-ebs-csi-driver = {
      service_account_role_name = module.ebs_csi_driver_role.iam_role_arn
    }
    coredns = {
      most_recent = true

      timeouts = {
        create = "25m"
        delete = "10m"
      }
    }
    kube-proxy = {}
  }

    tags = local.aws_tags
}