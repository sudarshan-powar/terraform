# =====================================================
# 🔹 Data Source: AWS Launch Template
# =====================================================
# This data source fetches an existing launch template 
# that will be used to deploy worker nodes for the EKS cluster.
# =====================================================
data "aws_launch_template" "eks_lt" {
  name = "${var.EKS_CLUSTER_NAME}_launch_template" # 🔹 Uses a pre-defined launch template

  depends_on = [ aws_launch_template.eks_launch_template ] # 🔹 Ensures launch template exists before fetching
}

# =====================================================
# 🏗️ AWS EKS Node Group
# =====================================================
# This resource defines an EKS managed node group that will automatically 
# handle worker nodes for the Kubernetes cluster.
# =====================================================
resource "aws_eks_node_group" "project_eks_node_group" {
  cluster_name    = aws_eks_cluster.project_eks.name  # 🔹 Associate node group with the EKS cluster
  node_group_name = var.EKS_NODE_GROUP_NAME           # 🔹 Node group name from variables
  node_role_arn   = aws_iam_role.eks_node_group_role.arn  # 🔹 IAM Role required for worker nodes
  subnet_ids      = [var.VPC_PRIVATE_SUBNET_ID_1, var.VPC_PRIVATE_SUBNET_ID_2] # 🔹 Deploy nodes in private subnets

  # =====================================================
  # 🔹 Launch Template Configuration
  # =====================================================
  # The launch template specifies the AMI, instance type, and other EC2 settings.
  launch_template {
    id      = data.aws_launch_template.eks_lt.id  # 🔹 Fetches launch template ID
    version = data.aws_launch_template.eks_lt.latest_version # 🔹 Uses the latest version of the template
  }

  # =====================================================
  # 📈 Node Scaling Configuration
  # =====================================================
  # Defines the scaling settings for the node group.
  scaling_config {
    desired_size = 1  # 🔹 Initial number of worker nodes
    max_size     = 5  # 🔹 Maximum number of nodes in the group
    min_size     = 1  # 🔹 Minimum number of nodes in the group
  }

  # =====================================================
  # 🔄 Update Strategy
  # =====================================================
  # Defines how updates are applied to the node group.
  update_config {
    max_unavailable = 1  # 🔹 Controls how many nodes can be replaced simultaneously during an update
  }

  # =====================================================
  # ⚠️ Dependencies to Avoid Deletion Issues
  # =====================================================
  # These dependencies ensure that IAM Role permissions are set up 
  # before the node group and prevent issues when deleting the cluster.
  depends_on = [
    aws_eks_cluster.project_eks,
    aws_iam_role_policy_attachment.Cluster_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.Cluster_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.Cluster_AmazonEC2ContainerRegistryPullOnly,
    aws_launch_template.eks_launch_template
  ]

  # =====================================================
  # 🏷️ Tags for Identification
  # =====================================================
  tags = {
    Name = var.EKS_CLUSTER_NAME
    Terraform = "True"
    "k8s.io/cluster-autoscaler/enabled" = "true" # 🔹 Allows Cluster Autoscaler to manage this node group
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}" = "owned" # 🔹 Marks the node group as part of the cluster
  }
}
