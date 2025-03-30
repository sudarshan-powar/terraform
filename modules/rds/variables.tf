# =====================================================
# 📌 AWS RDS Variables
# =====================================================
# These variables define the configuration for the RDS database.
# =====================================================

# 🔹 Storage Configuration
variable "DB_STORAGE_SIZE" {
  description = "Allocated storage for the RDS instance (GB)"
  type        = number
  default     = 22
}

variable "MAX_ALLOCATED_STORAGE" {
  description = "Maximum storage threshold for autoscaling (GB)"
  type        = number
  default     = 1000
}

# 🔹 Database Configuration
variable "DB_ENGINE" {
  description = "Database engine (e.g., mysql, postgres, sqlserver)"
  type        = string
  default     = "mysql"
}

variable "ENGINE_VERSION" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "DB_INSTANCE_CLASS" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.m5.large"
}

variable "DB_INSTANCE_IDENTIFIER" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "DB_NAME" {
  description = "Name for the database"
  type        = string
}

variable "DB_USERNAME" {
  description = "Master username for the database"
  type        = string
}

variable "DB_PASSWORD" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

# 🔹 Storage Settings
variable "STORAGE_TYPE" {
  description = "Storage type (gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}

variable "IOPS" {
  description = "Provisioned IOPS for the database (if applicable)"
  type        = number
  default     = 3000
}

variable "STORAGE_THROUGHPUT" {
  description = "Storage throughput in MiBps"
  type        = number
  default     = 125
}

# 🔹 Network and Security
variable "VPC_ID" {
  description = "VPC ID for the database instance"
  type        = string
}

variable "EC2_PRIVATE_SECURITY_GROUP_ID" {
  description = "Security group for EC2 access to RDS"
  type        = string
}

variable "DB_SUBNET_PRIVATE_1" {
  description = "Private subnet ID 1 for RDS"
  type        = string
}

variable "DB_SUBNET_PRIVATE_2" {
  description = "Private subnet ID 2 for RDS"
  type        = string
}

variable "DB_PRIVATE_SECURITY_GROUP_NAME" {
  description = "Name of the RDS security group"
  type        = string
  default     = "Project_DB_Security_Group"
}

# 🔹 Backup & Maintenance
variable "BACKUP_RETENTION_PERIOD" {
  description = "Number of days for automated backups retention"
  type        = number
  default     = 7
}

variable "BACKUP_WINDOW" {
  description = "Preferred backup window (UTC format)"
  type        = string
  default     = "03:00-05:00"
}

variable "AUTO_MINOR_VERSION_UPGRADE" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "DB_SKIP_FINAL_SNAPSHOT" {
  description = "Skip the final snapshot of the DB instance if deleted"
  type        = bool
  default     = true
}

# 🔹 Access & Security
variable "PUBLICLY_ACCESSIBLE" {
  description = "Should the RDS instance be publicly accessible?"
  type        = bool
  default     = false
}

variable "DB_PORT" {
  description = "Database port (e.g., 3306 for MySQL, 1433 for SQL Server)"
  type        = number
  default     = 3306
}

variable "DB_DELETION_PROTECTION" {
  description = "Protect RDS from accidental deletion"
  type        = bool
  default     = false
}

variable "DB_LICENSE_MODEL" {
  description = "License model for the RDS instance"
  type        = string
  default     = "license-included"
}

variable "MULTI_AZ" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}