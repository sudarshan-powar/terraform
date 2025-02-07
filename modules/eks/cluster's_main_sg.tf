# =====================================================
# 🏗️ EKS Cluster Main Security Group
# =====================================================
# This file defines the main security group for the EKS cluster.
# It controls inbound and outbound traffic rules, ensuring 
# proper communication between EKS components.
# =====================================================

# 🔐 Security Group for EKS Cluster
resource "aws_security_group" "eks_main_cluster_sg" {
  vpc_id = var.VPC_ID  # Associate the security group with the provided VPC
  name   = "${var.EKS_CLUSTER_NAME}-sg"  # Security group name derived from EKS cluster name

  # 🌍 Outbound Traffic Rule (Allow All)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any destination
  }

  # 🏷️ Tags for Identification and Auto-Discovery
  tags = {
    Terraform                                           = "True"
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}"     = "owned"  # Marks the SG as part of the EKS cluster
  #  "aws:eks:cluster-name"                              = var.EKS_CLUSTER_NAME  # Uncomment if needed
    Name                                                = "${var.EKS_CLUSTER_NAME}-sg"  # Name of the security group
  }
}

# 🔄 Self-Referencing Security Group Rule
resource "aws_vpc_security_group_ingress_rule" "eks_main_sg_self_rule" {
  security_group_id             = aws_security_group.eks_main_cluster_sg.id  # Attach rule to this SG
  referenced_security_group_id  = aws_security_group.eks_main_cluster_sg.id  # Allow traffic from itself
  ip_protocol                   = "-1"  # Allow all protocols

  depends_on = [ aws_security_group.eks_main_cluster_sg ]  # Ensure SG is created before applying this rule
}
