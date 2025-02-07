# =====================================================
# 🚀 AWS Security Group for RDS
# =====================================================
# This security group controls access to the RDS database.
# It allows connections from EC2 instances within the private network.
# =====================================================

resource "aws_security_group" "db_rds_sg" {
  vpc_id = var.VPC_ID  # VPC where the security group is created
  name   = var.DB_PRIVATE_SECURITY_GROUP_NAME # Security Group Name

  # ✅ Allow inbound traffic from EC2 instances (for database connection)
  ingress {
    from_port   = 1433  # SQL Server Port (Change based on DB Engine)
    to_port     = 1433
    protocol    = "tcp"
    security_groups = [var.EC2_PRIVATE_SECURITY_GROUP_ID] # Allow from EC2 SG
  }

  # 🌍 Allow outbound traffic to the internet (if needed)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = var.DB_PRIVATE_SECURITY_GROUP_NAME
    Terraform = "True"
  }
}
