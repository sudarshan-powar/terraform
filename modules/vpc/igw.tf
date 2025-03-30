#######################################
# Internet Gateway
# Allows public access to the internet from the VPC.
#######################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project-vpc.id # Attaches the internet gateway to the VPC

  tags = {
    Name      = "${var.PROJECT_VPC_NAME}-IGW" # Names the internet gateway
    Terraform = "True"
  }
}