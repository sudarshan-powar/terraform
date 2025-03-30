# =====================================================
# 🚀 AWS RDS Configuration
# =====================================================
# This Terraform file provisions an AWS RDS instance with:
# - Custom storage settings
# - Multi-AZ deployment (if enabled)
# - Automated backups
# =====================================================

# ✅ Create RDS Subnet Group (Required for RDS Deployment)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [var.DB_SUBNET_PRIVATE_1, var.DB_SUBNET_PRIVATE_2] # Private subnets

  tags = {
    Name      = "Project RDS Subnet Group"
    Terraform = "True"
  }
}

# ✅ Provision RDS Instance
resource "aws_db_instance" "project_rds" {
  allocated_storage     = var.DB_STORAGE_SIZE
  max_allocated_storage = var.MAX_ALLOCATED_STORAGE
  #db_name                 = var.DB_NAME
  engine                     = var.DB_ENGINE
  engine_version             = var.ENGINE_VERSION
  instance_class             = var.DB_INSTANCE_CLASS
  license_model              = var.DB_LICENSE_MODEL
  identifier                 = var.DB_INSTANCE_IDENTIFIER
  username                   = var.DB_USERNAME
  password                   = var.DB_PASSWORD
  storage_type               = var.STORAGE_TYPE
  iops                       = var.IOPS
  storage_throughput         = var.STORAGE_THROUGHPUT
  multi_az                   = var.MULTI_AZ
  publicly_accessible        = var.PUBLICLY_ACCESSIBLE
  backup_retention_period    = var.BACKUP_RETENTION_PERIOD
  backup_window              = var.BACKUP_WINDOW
  auto_minor_version_upgrade = var.AUTO_MINOR_VERSION_UPGRADE
  skip_final_snapshot        = var.DB_SKIP_FINAL_SNAPSHOT
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.db_rds_sg.id]
  port                       = var.DB_PORT
  deletion_protection        = var.DB_DELETION_PROTECTION # Prevent accidental deletion

  tags = {
    #Name      = var.DB_NAME # Uncomment if needed
    Terraform = "True"
  }
}
