# ================================
# 🔐 EC2 Security Groups
# ================================

# Security Group for Private EC2 Instances
resource "aws_security_group" "ec2_private_sg" {
  vpc_id = var.VPC_ID
  name   = var.EC2_PRIVATE_SECURITY_GROUP_NAME

  # Allow all outbound traffic (egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound SSH only from the Public Security Group
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_public_sg.id] # Only allow SSH from Public SG
  }

  tags = {
    Name      = var.EC2_PRIVATE_SECURITY_GROUP_NAME
    Terraform = "True"
  }
}

# Security Group for Public EC2 Instances
resource "aws_security_group" "ec2_public_sg" {
  vpc_id = var.VPC_ID
  name   = var.EC2_PUBLIC_SECURITY_GROUP_NAME

  # Allow SSH access from anywhere (For Public Instances)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (Can be restricted to a specific IP)
  }

  # Allow all outbound traffic (egress)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = var.EC2_PUBLIC_SECURITY_GROUP_NAME
    Terraform = "True"
  }
}
