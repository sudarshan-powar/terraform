# =====================================================
# 🏗️ Amazon EKS Cluster Deployment
# =====================================================
# This Terraform resource creates an Amazon EKS Cluster.
# It provisions the necessary networking and IAM permissions 
# required for the cluster to operate efficiently.
# =====================================================

resource "aws_eks_cluster" "project_eks" {
  # 📌 Cluster Name
  name = var.EKS_CLUSTER_NAME

  # 🎭 IAM Role assigned to the EKS cluster
  role_arn = aws_iam_role.iam_cluster_role.arn

  # 🔹 Kubernetes Version
  version = var.KUBERNETES_VERSION

  # 🌐 Networking Configuration
  vpc_config {
    endpoint_private_access = true   # Enable private access
    endpoint_public_access  = true   # Enable public access

    # 🏗️ Subnets used by the EKS cluster
    subnet_ids = [
      var.VPC_PRIVATE_SUBNET_ID_1,
      var.VPC_PRIVATE_SUBNET_ID_2,
      var.VPC_PUBLIC_SUBNET_ID_1,
      var.VPC_PUBLIC_SUBNET_ID_2
    ]

    # 🔒 Security Group for EKS Cluster
    security_group_ids = [aws_security_group.eks_main_cluster_sg.id]
  }

  # 🚀 Dependency Handling
  # Ensures IAM Role permissions and Security Groups are available
  depends_on = [
    aws_security_group.eks_main_cluster_sg,
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSComputePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSBlockStoragePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSLoadBalancingPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSNetworkingPolicy,
  ]

  # 🏷️ Tags for resource identification
  tags = {
    Name        = var.EKS_CLUSTER_NAME
    Terraform   = "True"
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}" = "owned"
  }
}
