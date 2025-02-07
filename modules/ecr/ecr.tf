# =====================================================
# 🐳 Amazon Elastic Container Registry (ECR)
# =====================================================
# This Terraform configuration creates an AWS ECR repository for storing
# container images. It includes encryption, tag mutability, image scanning,
# and force delete options.
# =====================================================

resource "aws_ecr_repository" "ecr" {
  name                 = var.ECR_REPOSITORY_NAME  # Sets the name of the ECR repository
  image_tag_mutability = var.MUTABILITY  # Defines whether image tags can be overwritten

  # 🔐 Encryption Configuration
  encryption_configuration {
    encryption_type = var.ENCRYPTION_TYPE  # Defines encryption type (AES256 or KMS)
  }

  force_delete = var.FORCE_DELETE  # Allows force deletion even if images exist

  # 🛡️ Image Scanning Configuration
  image_scanning_configuration {
    scan_on_push = var.IMAGE_SCAN  # Enables scanning of images upon push
  }

  tags = {
    Terraform = "True"
    Name      = var.ECR_REPOSITORY_NAME
  }
}