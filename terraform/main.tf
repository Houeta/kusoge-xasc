##
# EKS Module
##

locals {
  cluster_name = "${var.project}-${var.env}-eks"
  cluster_version = "1.29"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name = local.cluster_name
  cluster_version = local.cluster_version

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {}
    
  }

}
