output "global_prefix" {
  value = local.global_prefix
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = <<-EOT
    export KUBECONFIG="/tmp/${module.eks.cluster_name}"
    aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name} --profile ${var.profile}
  EOT
}

output "argocd_url" {
  value = "https://argocd.${data.aws_route53_zone.domain.name}"
}