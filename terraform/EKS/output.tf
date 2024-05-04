output "global_prefix" {
  value = local.global_prefix
}

output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = <<-EOT
    export KUBECONFIG="/tmp/${aws_eks_cluster.this.name}"
    aws eks --region ${var.region} update-kubeconfig --name ${aws_eks_cluster.this.name} --profile ${var.iam_profile}
  EOT
}

output "argocd_url" {
  value = "https://argocd.${local.domain_name}"
}