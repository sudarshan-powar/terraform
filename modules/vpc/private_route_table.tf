#######################################
# Private Route Table
# Defines the route table and associations for private subnets.
#######################################

resource "aws_route_table" "private_route_tb" {
  vpc_id = aws_vpc.project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project-nat-gw.id
  }

  tags = {
    Name = "${var.PROJECT_VPC_NAME}-Private-Route-Tb"
    Terraform = "True"
  }
}

resource "aws_route_table_association" "pri_sub_association_1" {
  subnet_id      = aws_subnet.private_subnet-1.id
  route_table_id = aws_route_table.private_route_tb.id
}

resource "aws_route_table_association" "pri_sub_association_2" {
  subnet_id      = aws_subnet.private_subnet-2.id
  route_table_id = aws_route_table.private_route_tb.id
}
