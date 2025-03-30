# ================================
# 🌍 Terraform Provider Configuration
# ================================
# This file configures the required Terraform providers and authentication 
# details necessary for managing AWS resources and Kubernetes via Helm.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # ✅ Defines the AWS provider source
      version = "5.84.0"        # ✅ Specifies the required AWS provider version
    }
  }
}

# ================================
# 🔑 AWS Provider Configuration
# ================================
provider "aws" {
  access_key = var.AWS_ACCESS_KEY # ✅ AWS Access Key (use environment variables in production)
  secret_key = var.AWS_SECRET_KEY # ✅ AWS Secret Key (use environment variables in production)
  region     = var.AWS_REGION     # ✅ AWS Region where resources will be deployed
}