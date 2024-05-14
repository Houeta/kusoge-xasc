# Here we must set our profile, otherwise infra will be created in the root account
provider "aws" {
  region  = var.region
  profile = var.iam_profile
}

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  config_path            = "~/.kube/config"
}

data "aws_availability_zones" "available" {}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.this.token
    config_path            = "~/.kube/config"
  }
}

