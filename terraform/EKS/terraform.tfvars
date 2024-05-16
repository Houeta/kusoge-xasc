# AWS account config
region      = "eu-central-1"
iam_profile = "mfa"

# General 
env     = "dev"
project = "kusoge"

vpc_id      = "vpc-06ae62935ffb33e2b"
subnets_ids = ["subnet-0b27929ad2896d99f", "subnet-0c15a8c6856de7853", "subnet-01a5c422124b1c69e"]

node_instances_type = ["t3.large"]

zone_name = "watashinoheyadesu.pp.ua"

tags = {
  Environment = "test"
  TfControl   = "true"
}

node_additional_tags = {
  "arch" = "amd"
}

#ArgoCD
argocd_namespace         = "argocd"
argocd_helmchart_version = "6.7.17"

argocd_github_client_id     = "<your client id>"
argocd_github_client_secret = "<your client secret>"
argocd_github_org_name      = "Houeta-org"
