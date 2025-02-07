# =====================================================
# 🎛️ ECR Module Input Variables
# =====================================================
# These variables configure the ECR repository, defining its name, 
# encryption settings, tag mutability, and security features.
# =====================================================

variable "ECR_REPOSITORY_NAME" {
  description = "The name for the ECR repository"
  type        = string
  default     = "Project_ECR_Repo"
}

variable "PROJECT_NAME" {
  description = "The name of the project for Cert Manager ECR repository"
  type        = string
}

variable "ENCRYPTION_TYPE" {
  description = "The encryption type used for the repository (AES256 or KMS)"
  type        = string
  default     = "AES256"
}

variable "MUTABILITY" {
  description = "Defines whether image tags in the repository can be overwritten (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "FORCE_DELETE" {
  description = "Allows deletion of the repository even if it contains images"
  type        = bool
  default     = true
}

variable "IMAGE_SCAN" {
  description = "Enables automatic scanning of container images upon push"
  type        = bool
  default     = false
}
