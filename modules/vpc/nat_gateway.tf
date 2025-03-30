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