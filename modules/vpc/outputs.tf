#######################################
# Outputs
# This file defines the output values for the VPC module.
#######################################

output "vpc_id" {
  value = aws_vpc.project-vpc.id
}

output "vpc_arn" {
  value = aws_vpc.project-vpc.arn
}

output "public_subnet_id_1" {
  value = aws_subnet.public_subnet-1.id
}

output "public_subnet_id_2" {
  value = aws_subnet.public_subnet-2.id
}

output "private_subnet_id_1" {
  value = aws_subnet.private_subnet-1.id
}

output "private_subnet_id_2" {
  value = aws_subnet.private_subnet-2.id
}

output "public_route_tb" {
  value = aws_route_table.public_route_tb.id
}

output "private_route_tb" {
  value = aws_route_table.private_route_tb.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gw_id" {
  value = aws_nat_gateway.project-nat-gw.id
}
