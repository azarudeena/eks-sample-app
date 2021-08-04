resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = var.cluster-name
  node_group_name = "${var.cluster-name}-default-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.aws_subnet_ids.private.ids
  scaling_config {
    desired_size = var.desired-capacity
    max_size     = var.max-size
    min_size     = var.min-size
  }
  instance_types = [
    var.node-instance-type
  ]
  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
  ]
  tags = {
    Name = "${var.cluster-name}-default-node-group"
  }
}
