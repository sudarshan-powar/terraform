#######################################
# Public Subnets
# Defines the public subnets within the VPC.
#######################################

resource "aws_subnet" "public_subnet-1" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = var.PUBLIC_SUBNET_CIDR_1
  assign_ipv6_address_on_creation = var.IPV6_ON_CREATION
  availability_zone = var.AZ_PUBLIC_1
  map_public_ip_on_launch = true # Enables auto-assign public IP

  tags = {
    Name = "${var.PROJECT_VPC_NAME}-public-subnet-1"
    "kubernetes.io/role/elb" = "1"
    Terraform = "True"
    "subnet" = "public"
  }
}

resource "aws_subnet" "public_subnet-2" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = var.PUBLIC_SUBNET_CIDR_2
  assign_ipv6_address_on_creation = var.IPV6_ON_CREATION
  availability_zone = var.AZ_PUBLIC_2
  map_public_ip_on_launch = true # Enables auto-assign public IP

  tags = {
    Name = "${var.PROJECT_VPC_NAME}-public-subnet-2"
    "kubernetes.io/role/elb" = "1"
    Terraform = "True"
    "subnet" = "public"
  }
}
