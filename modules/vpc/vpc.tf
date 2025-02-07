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

#######################################
# Internet Gateway
# Allows public access to the internet from the VPC.
#######################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project-vpc.id  # Attaches the internet gateway to the VPC

  tags = {
    Name      = "${var.PROJECT_VPC_NAME}-IGW"  # Names the internet gateway
    Terraform = "True"
  }
}

#######################################
# Elastic IP (EIP)
# Used for the NAT Gateway to maintain a static IP address.
#######################################

resource "aws_eip" "eip_ngw" {
  domain = "vpc"  # Associates the EIP with the VPC

  tags = {
    Terraform = "True"
  }
}

#######################################
# NAT Gateway
# Allows instances in private subnets to access the internet while remaining private.
#######################################

resource "aws_nat_gateway" "project-nat-gw" {
  allocation_id = aws_eip.eip_ngw.id  # Associates the EIP with the NAT Gateway
  subnet_id     = aws_subnet.public_subnet-1.id  # Places NAT Gateway in a public subnet

  tags = {
    Name      = "${var.PROJECT_VPC_NAME}-Nat_GW"  # Assigns a name to the NAT Gateway
    Terraform = "True"
  }

  # Ensures that the NAT Gateway is created only after the Internet Gateway and EIP are ready.
  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.eip_ngw
  ]
}
