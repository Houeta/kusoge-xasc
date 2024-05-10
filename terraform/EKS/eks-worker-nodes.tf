locals {
  node_group_name = "${local.global_prefix}-amd"
}

resource "aws_eks_node_group" "amd" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnets_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  ami_type       = var.node_ami_type
  instance_types = var.node_instances_type

  labels = merge(var.node_additional_tags,
  {
    "node-type" : "general"
  })

  depends_on = [
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.kubeedge-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = merge(
    var.tags,
    { Name = "${local.node_group_name}-ng" }
  )
}
