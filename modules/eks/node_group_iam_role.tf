# =====================================================
# 🔹 IAM Role for EKS Node Group
# =====================================================
# This Terraform resource creates an AWS IAM Role for 
# the EKS Node Group, allowing worker nodes to assume 
# necessary permissions required to interact with the cluster.
# =====================================================

resource "aws_iam_role" "eks_node_group_role" {
  # 📌 IAM Role Name
  name = var.EKS_NODE_GROUP_ROLE_NAME

  # 🔹 Assume Role Policy for EC2 Instances
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# =====================================================
# 📌 IAM Policy Attachments for EKS Node Group Role
# =====================================================
# These policies grant necessary permissions to worker nodes.
# =====================================================

# 🛠️ Amazon EKS Worker Node Policy
resource "aws_iam_role_policy_attachment" "Cluster_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

# 🏗️ Amazon EC2 Container Registry (ECR) Pull-Only Access
resource "aws_iam_role_policy_attachment" "Cluster_AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

# 🌐 Amazon EKS CNI Policy (Networking)
resource "aws_iam_role_policy_attachment" "Cluster_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

# ⚡ AutoScaling Full Access for Scaling EKS Nodes
resource "aws_iam_role_policy_attachment" "Cluster_AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.eks_node_group_role.name
}
