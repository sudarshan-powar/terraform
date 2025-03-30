#######################################
# Private Subnets
# Defines the private subnets within the VPC.
#######################################

resource "aws_subnet" "private_subnet-1" {
  vpc_id                          = aws_vpc.project-vpc.id
  cidr_block                      = var.PRIVATE_SUBNET_CIDR_1
  assign_ipv6_address_on_creation = var.IPV6_ON_CREATION
  availability_zone               = var.AZ_PRIVATE_1

  tags = {
    Name                              = "${var.PROJECT_VPC_NAME}-private-subnet-1"
    "kubernetes.io/role/internal-elb" = "1"
    Terraform                         = "True"
    "subnet"                          = "private"
  }
}

resource "aws_subnet" "private_subnet-2" {
  vpc_id                          = aws_vpc.project-vpc.id
  cidr_block                      = var.PRIVATE_SUBNET_CIDR_2
  assign_ipv6_address_on_creation = var.IPV6_ON_CREATION
  availability_zone               = var.AZ_PRIVATE_2

  tags = {
    Name                              = "${var.PROJECT_VPC_NAME}-private-subnet-2"
    "kubernetes.io/role/internal-elb" = "1"
    Terraform                         = "True"
    "subnet"                          = "private"
  }
}