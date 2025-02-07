# =====================================================
# 📤 AWS RDS Outputs
# =====================================================
# These outputs provide useful information about the RDS instance.
# =====================================================

# ✅ RDS Instance ARN
output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.project_rds.arn
}

# ✅ RDS Instance ID
output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.project_rds.id
}

# ✅ RDS Security Group ID
output "db_rds_sg_id" {
  description = "ID of the security group for RDS"
  value       = aws_security_group.db_rds_sg.id
}

# ✅ RDS Database Name (Uncomment if using DB_NAME)
output "db_name" {
  description = "Database name of the RDS instance"
  value       = aws_db_instance.project_rds.db_name
}
