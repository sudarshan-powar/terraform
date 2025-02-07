# =====================================================
# 🎯 EKS Cluster Outputs
# =====================================================
# These outputs provide useful information about the created EKS cluster.
# They can be referenced in other modules or external integrations.
# =====================================================

# 🔹 EKS Cluster Name
output "project_eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.project_eks.name
}

# 🔹 EKS Cluster ID
output "eks_cluster_id" {
  description = "Unique ID of the EKS cluster"
  value       = aws_eks_cluster.project_eks.id
}

# 🔹 EKS Cluster API Endpoint
output "eks_cluster_endpoint" {
  description = "API server endpoint for the EKS cluster"
  value       = aws_eks_cluster.project_eks.endpoint
}

# 🔹 EKS Cluster Certificate Authority Data
output "eks_cluster_ca" {
  description = "Base64 encoded certificate authority data for cluster authentication"
  value       = aws_eks_cluster.project_eks.certificate_authority[0].data
}

# 🔹 EKS OIDC Issuer URL
output "eks_oidc_issuer" {
  description = "OIDC provider URL for IAM roles and authentication"
  value       = aws_eks_cluster.project_eks.identity[0].oidc[0].issuer
}

# 🔹 EKS Cluster ARN
output "project_eks_cluster_arn" {
  description = "Amazon Resource Name (ARN) of the EKS cluster"
  value       = aws_eks_cluster.project_eks.arn
}

# =====================================================
# 🔹 IAM Role Outputs for EKS Cluster
# =====================================================
# These outputs provide details about the IAM role used by the EKS cluster.
# Useful for referencing permissions and role management.
# =====================================================

# 🔹 IAM Cluster Role Name
output "iam_cluster_role_name" {
  description = "Name of the IAM role assigned to the EKS cluster"
  value       = aws_iam_role.iam_cluster_role.name
}

# 🔹 IAM Cluster Role ID
output "iam_cluster_role_id" {
  description = "Unique ID of the IAM role assigned to the EKS cluster"
  value       = aws_iam_role.iam_cluster_role.id
}

# 🔹 IAM Cluster Role ARN
output "iam_cluster_role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM role assigned to the EKS cluster"
  value       = aws_iam_role.iam_cluster_role.arn
}

# =====================================================
# 🚀 EKS Node Group Outputs
# =====================================================
# These outputs provide details about the EKS managed node group,
# allowing for easier access and reference in other modules.
# =====================================================

# 🔹 EKS Node Group ID
output "node_group_id" {
  description = "ID of the EKS node group"
  value       = aws_eks_node_group.project_eks_node_group.id
}

# 🔹 EKS Node Group Name
output "node_group_name" {
  description = "Name of the EKS node group"
  value       = aws_eks_node_group.project_eks_node_group.node_group_name
}
