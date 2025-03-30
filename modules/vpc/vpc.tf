#######################################
# VPC Configuration
# This file defines the VPC setup for the project.
#######################################

resource "aws_vpc" "project-vpc" {
  cidr_block           = var.VPC_CIDR_BLOCK  # Defines the CIDR block for the VPC
  enable_dns_support   = true   # Enables internal DNS resolution
  enable_dns_hostnames = true   # Enables hostname allocation

  tags = {
    Name      = var.PROJECT_VPC_NAME  # Assigns the project name to the VPC
    Terraform = "True"  # Identifies that this resource is managed by Terraform
  }
}
