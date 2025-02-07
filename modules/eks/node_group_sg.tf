# =====================================================
# 🔹 AWS Security Group for EKS Node Group
# =====================================================
# This Terraform configuration defines security group rules 
# for EKS worker nodes, ensuring secure communication with
# the EKS cluster and other nodes.
# =====================================================

# =====================================================
# 📌 Define Security Group for EKS Node Group
# =====================================================
resource "aws_security_group" "eks_node_group_sg" {
  vpc_id = var.VPC_ID
  name   = "${var.EKS_NODE_GROUP_NAME}-sg"  # 🔹 Naming based on Node Group

  # =====================================================
  # 📤 Egress Rule (Allow all outgoing traffic)
  # =====================================================
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # 🔹 Allow outbound traffic to all destinations
  }

  # =====================================================
  # 🏷️ Tags for Identification
  # =====================================================
  tags = {
    Terraform                                             = "True"
    "kubernetes.io/node-group/${var.EKS_NODE_GROUP_NAME}" = "owned"
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}"       = "owned"
    Name                                                  = "${var.EKS_NODE_GROUP_NAME}-sg"
  }

  depends_on = [ aws_eks_cluster.project_eks ]
}

# =====================================================
# 🔹 Self-Allow Rule (Nodes within the same SG can communicate)
# =====================================================
resource "aws_vpc_security_group_ingress_rule" "eks_node_group_sg_self_rule" {
  security_group_id             = aws_security_group.eks_node_group_sg.id
  referenced_security_group_id  = aws_security_group.eks_node_group_sg.id
  ip_protocol                   = "-1"  # 🔹 Allow all traffic within the SG

  depends_on = [ aws_security_group.eks_node_group_sg ]
}

# =====================================================
# 🔹 Allow Traffic from Main Cluster SG to Node Group SG
# =====================================================
resource "aws_vpc_security_group_ingress_rule" "eks_node_group_to_main_rule" {
  security_group_id             = aws_security_group.eks_node_group_sg.id
  referenced_security_group_id  = aws_security_group.eks_main_cluster_sg.id
  ip_protocol                   = "-1"  # 🔹 Allow all traffic

  depends_on = [ aws_security_group.eks_node_group_sg ]
}

# =====================================================
# 🔹 Allow Traffic from Node Group SG to Main Cluster SG
# =====================================================
resource "aws_vpc_security_group_ingress_rule" "eks_main_to_node_group_rule" {
  security_group_id             = aws_security_group.eks_main_cluster_sg.id
  referenced_security_group_id  = aws_security_group.eks_node_group_sg.id
  ip_protocol                   = "-1"  # 🔹 Allow all traffic

  depends_on = [ aws_security_group.eks_node_group_sg ]
}

# =====================================================
# 🔹 Allow SSH Traffic from Public Server SG to Node Group SG
# =====================================================
resource "aws_vpc_security_group_ingress_rule" "ssh_to_node_group_rule" {
  security_group_id             = aws_security_group.eks_node_group_sg.id
  referenced_security_group_id  = var.PUBLIC_SERVER_SECURITY_GROUP
  ip_protocol                   = "-1"  # 🔹 Allow all traffic (SSH, etc.)

  depends_on = [ aws_security_group.eks_node_group_sg ]
}
