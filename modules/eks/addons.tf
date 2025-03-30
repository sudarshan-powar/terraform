# 📌 CoreDNS Add-on
resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.project_eks.name
  addon_name                  = "coredns"
  addon_version               = var.EKS_COREDNS_VERSION # ✅ Using variable
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [aws_eks_node_group.project_eks_node_group]
}

# 📌 Kube-proxy Add-on
resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.project_eks.name
  addon_name                  = "kube-proxy"
  addon_version               = var.EKS_KUBE_PROXY_VERSION # ✅ Using variable
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [aws_eks_node_group.project_eks_node_group]
}

# 📌 Metrics Server Add-on
resource "aws_eks_addon" "metrics_server" {
  cluster_name                = aws_eks_cluster.project_eks.name
  addon_name                  = "metrics-server"
  addon_version               = var.EKS_METRICS_SERVER_VERSION # ✅ Using variable
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [aws_eks_node_group.project_eks_node_group]
}

# 🛑 Pod Identity Server (Commented Out)
# Uncomment if needed
# resource "aws_eks_addon" "pod_identity_server" {
#   cluster_name    = aws_eks_cluster.project_eks.name
#   addon_name      = "pod-identity-server"
#   addon_version   = var.EKS_POD_IDENTITY_VERSION  # ✅ Using variable
#   resolve_conflicts_on_update = "PRESERVE"
#
#   depends_on = [aws_eks_node_group.project_eks_node_group]
# }

# 📌 Amazon VPC CNI Add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = var.EKS_CLUSTER_NAME
  addon_name                  = "vpc-cni"
  addon_version               = var.EKS_VPC_CNI_VERSION # ✅ Using variable
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.vpc_cni_role.arn

  depends_on = [
    aws_iam_role.vpc_cni_role,
    aws_iam_openid_connect_provider.eks_oidc,
    null_resource.annotate_aws_node
  ]
}
