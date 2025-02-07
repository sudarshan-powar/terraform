# =====================================================
# 🔹 IAM Role for Amazon EKS Cluster
# =====================================================
# This Terraform resource defines the IAM Role for 
# the EKS Cluster, granting necessary permissions to
# interact with AWS services.
# =====================================================

resource "aws_iam_role" "iam_cluster_role" {
  # 📌 IAM Role Name for EKS Cluster
  name = var.IAM_CLUSTER_ROLE_NAME

  # 🔹 Assume Role Policy - Grants AWS EKS Service the Ability to Assume This Role
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
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# =====================================================
# 📌 IAM Policy Attachments for EKS Cluster Role
# =====================================================
# These policies grant the required permissions for 
# managing compute, networking, storage, and security.
# =====================================================

# 🛠️ Amazon EKS Cluster Management Policy
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_cluster_role.name
}

# 💻 Amazon EKS Compute Policy
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSComputePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = aws_iam_role.iam_cluster_role.name
}

# 🗄️ Amazon EKS Block Storage Policy
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSBlockStoragePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.iam_cluster_role.name
}

# ⚖️ Amazon EKS Load Balancing Policy
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSLoadBalancingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.iam_cluster_role.name
}

# 🌐 Amazon EKS Networking Policy
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSNetworkingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.iam_cluster_role.name
}
