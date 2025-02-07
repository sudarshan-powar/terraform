# =====================================================
# 🔹 EKS VPC CNI Role & OIDC Provider Configuration
# =====================================================
# This Terraform script:
# 1️⃣ Fetches the EKS Cluster details.
# 2️⃣ Retrieves the TLS Certificate for OIDC Provider.
# 3️⃣ Creates an OpenID Connect Provider (OIDC) for the EKS cluster.
# 4️⃣ Defines an IAM role for VPC CNI (IRSA) with necessary policies.
# 5️⃣ Attaches the required IAM policies to the role.
# 6️⃣ Annotates the aws-node service account with the IAM role.
# =====================================================

# =====================================================
# 📌 Fetch EKS Cluster Details
# =====================================================
data "aws_eks_cluster" "eks" {
  name = var.EKS_CLUSTER_NAME

  depends_on = [aws_eks_cluster.project_eks]
}

# =====================================================
# 🔑 Fetch TLS Certificate for OIDC Provider
# =====================================================
data "tls_certificate" "eks_oidc_thumbprint" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.project_eks]
}

# =====================================================
# 🌐 OIDC PROVIDER FOR EKS
# 📌 Creates IAM Trust Relationship for Kubernetes Service Account Authentication
# =====================================================
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc_thumbprint.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.project_eks]
}

# =====================================================
# 🔹 IAM ROLE FOR VPC CNI (IRSA - IAM Role for Service Accounts)
# 📌 This role allows the aws-node DaemonSet to assume an IAM role 
#    using OpenID Connect authentication.
# =====================================================
resource "aws_iam_role" "vpc_cni_role" {
  name = "${var.EKS_CLUSTER_NAME}-vpc-cni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })
}

# =====================================================
# 🔹 Attach AmazonEKS_CNI_Policy (Required for VPC CNI)
# 📌 This policy allows EKS to manage networking for worker nodes.
# =====================================================
resource "aws_iam_role_policy_attachment" "attach_eks_cni" {
  role       = aws_iam_role.vpc_cni_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# =====================================================
# 🔹 Attach CloudWatch Logs Full Access Policy (Optional)
# 📌 Enables logging for aws-node and VPC CNI troubleshooting.
# =====================================================
resource "aws_iam_role_policy_attachment" "attach_cloudwatch" {
  role       = aws_iam_role.vpc_cni_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# =====================================================
# 🔹 Annotate aws-node Service Account with IAM Role
# 📌 This step ensures that aws-node DaemonSet can assume the IAM role
#    before deploying the VPC CNI add-on.
# =====================================================
resource "null_resource" "annotate_aws_node" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.AWS_REGION} --name ${var.EKS_CLUSTER_NAME}
      kubectl annotate serviceaccount aws-node \
        eks.amazonaws.com/role-arn="${aws_iam_role.vpc_cni_role.arn}" \
        -n kube-system --overwrite
    EOT
  }

  depends_on = [
    aws_eks_cluster.project_eks,
    aws_iam_openid_connect_provider.eks_oidc,
    aws_iam_role.vpc_cni_role
  ]
}
