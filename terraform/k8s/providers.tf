provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    token       = data.aws_eks_cluster_auth.cluster_auth.token
    config_path = "~/.kube/config"

    # exec {
    #   api_version = "client.authentication.k8s.io/v1beta1"
    #   command = "aws"
    #   args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", var.region]
    # }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  token       = data.aws_eks_cluster_auth.cluster_auth.token
  config_path = "~/.kube/config"
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command = "aws"
  #   args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", var.region]
  # }
}