# =====================================================
# 🎯 EKS Cluster Variables
# =====================================================
# These variables define the configuration for the AWS EKS cluster.
# This includes IAM roles, node groups, add-ons, networking, and AMI details.
# =====================================================

# 🔹 IAM Role for EKS Cluster
variable "IAM_CLUSTER_ROLE_NAME" {
  description = "IAM role name for the EKS cluster"
  type        = string
  default     = "project_EKS_IAM_Cluster_Role"
}

# 🔹 EKS Cluster Name
variable "EKS_CLUSTER_NAME" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "project_EKS_Cluster"
}

# 🔹 Security Group for Public Web Server (for SSH)
variable "PUBLIC_SERVER_SECURITY_GROUP" {
  description = "Security Group ID of the Public web server (used for SSH access)"
  type        = string
}

# 🔹 Node Group Name
variable "EKS_NODE_GROUP_NAME" {
  description = "Name of the EKS Node Group"
  type        = string
  default     = "project_EKS_Node_Group"
}

# 🔹 IAM Role for EKS Node Group
variable "EKS_NODE_GROUP_ROLE_NAME" {
  description = "IAM role name for EKS Node Group"
  type        = string
  default     = "project_EKS_Node_Group_Role"
}

# 🔹 Kubernetes Version
variable "KUBERNETES_VERSION" {
  description = "Version of Kubernetes for the EKS cluster"
  type        = string
  default     = "1.31"
}

# =====================================================
# 🚀 Networking Variables (VPC and Subnets)
# =====================================================

# 🔹 VPC ID
variable "VPC_ID" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

# 🔹 Private Subnet 1 for EKS Worker Nodes
variable "VPC_PRIVATE_SUBNET_ID_1" {
  description = "Private subnet ID for the first availability zone"
  type        = string
}

# 🔹 Private Subnet 2 for EKS Worker Nodes
variable "VPC_PRIVATE_SUBNET_ID_2" {
  description = "Private subnet ID for the second availability zone"
  type        = string
}

# 🔹 Public Subnet 1 (For Load Balancer / NAT)
variable "VPC_PUBLIC_SUBNET_ID_1" {
  description = "Public subnet ID for the first availability zone"
  type        = string
}

# 🔹 Public Subnet 2 (For Load Balancer / NAT)
variable "VPC_PUBLIC_SUBNET_ID_2" {
  description = "Public subnet ID for the second availability zone"
  type        = string
}

# =====================================================
# 🔹 EKS Node Group Configurations
# =====================================================

# 🔹 Instance Type for EKS Worker Nodes
variable "EKS_LAUNCH_TEMPLATE_INSTANCE_TYPE" {
  description = "Instance type used for EKS worker nodes"
  type        = string
  default     = "t2.micro"
}

# 🔹 EBS Volume Size for EKS Worker Nodes
variable "EKS_LAUNCH_TEMPLATE_VOLUME_SIZE" {
  description = "Size of the EBS volume for worker nodes (in GB)"
  type        = number
  default     = 20
}

# 🔹 EBS Volume Type for EKS Worker Nodes
variable "EKS_LAUNCH_TEMPLATE_VOLUME_TYPE" {
  description = "Type of the EBS volume for worker nodes"
  type        = string
  default     = "gp3"
}

# 🔹 Enable Detailed Monitoring for EKS Nodes
variable "EKS_NODES_DETAILED_MONITORING" {
  description = "Enable detailed monitoring for EKS worker nodes"
  type        = bool
  default     = false
}

# 🔹 Flag to Remove Old IAM Policies
variable "REMOVE_OLD_POLICY" {
  description = "Set to true to remove outdated IAM policies"
  type        = bool
  default     = false
}

# 🔹 AMI ID for EKS Worker Nodes
variable "WORKER_NODE_AMI_ID" {
  description = "AMI ID used for worker nodes in the launch template"
  type        = string
  default     = "ami-005cb9eccb9a1b0f2"
}

# =====================================================
# 🔹 Kubernetes Service Accounts and Namespaces
# =====================================================

# 🔹 Kubernetes Service Account Name
variable "SERVICE_ACCOUNT_NAME" {
  description = "Name of the Kubernetes service account"
  type        = string
  default     = "cluster-autoscaler"
}

# 🔹 Kubernetes Namespace
variable "NAMESPACE" {
  description = "Namespace in Kubernetes where workloads will run"
  type        = string
  default     = "kube-system"
}

# 🔹 AWS Region
variable "AWS_REGION" {
  description = "AWS region where the cluster is deployed"
  type        = string
  default     = "us-east-1"
}

# =====================================================
# 🔹 Amazon EKS Add-ons Variables
# =====================================================
# These variables define the versioning for various AWS EKS add-ons,
# ensuring compatibility with the cluster version.
# =====================================================

# 🔹 CoreDNS Add-on Version
variable "EKS_COREDNS_VERSION" {
  description = "Version of CoreDNS add-on for EKS"
  type        = string
  default     = "v1.11.3-eksbuild.1" # Replace with the latest AWS recommended version
}

# 🔹 Kube-proxy Add-on Version
variable "EKS_KUBE_PROXY_VERSION" {
  description = "Version of Kube-proxy add-on for EKS"
  type        = string
  default     = "v1.31.2-eksbuild.3" # Replace with the latest AWS recommended version
}

# 🔹 Metrics Server Add-on Version
variable "EKS_METRICS_SERVER_VERSION" {
  description = "Version of Metrics Server add-on for EKS"
  type        = string
  default     = "v0.7.2-eksbuild.1" # Replace with the latest AWS recommended version
}

# 🔹 Pod Identity Server Add-on Version (if enabled)
variable "EKS_POD_IDENTITY_VERSION" {
  description = "Version of Pod Identity Server add-on for EKS"
  type        = string
  default     = "v0.7.2-eksbuild.1" # Replace with the latest AWS recommended version
}

# 🔹 Amazon VPC CNI Add-on Version
variable "EKS_VPC_CNI_VERSION" {
  description = "Version of Amazon VPC CNI add-on for EKS"
  type        = string
  default     = "v1.19.0-eksbuild.1" # Replace with the latest AWS recommended version
}
