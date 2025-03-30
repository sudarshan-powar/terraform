#######################################
# Public Route Table
# Defines the route table and associations for public subnets.
#######################################

resource "aws_route_table" "public_route_tb" {
  vpc_id = aws_vpc.project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = "${var.PROJECT_VPC_NAME}-Public-Route-Tb"
    Terraform = "True"
  }
}

resource "aws_route_table_association" "pub_sub_association_1" {
  subnet_id      = aws_subnet.public_subnet-1.id
  route_table_id = aws_route_table.public_route_tb.id
}

resource "aws_route_table_association" "pub_sub_association_2" {
  subnet_id      = aws_subnet.public_subnet-2.id
  route_table_id = aws_route_table.public_route_tb.id
}