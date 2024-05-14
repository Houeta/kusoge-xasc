locals {
  cluster_name = "${local.global_prefix}-eks"
}


resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = aws_iam_role.cluster.arn
  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = var.subnets_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.kubeedge-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.kubeedge-cluster-AmazonEKSVPCResourceController,
  ]
  tags = merge(
    var.tags,
    { Name = local.cluster_name }
  )
}
