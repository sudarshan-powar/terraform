# ================================
# 📤 EC2 Outputs
# ================================

output "ami_private_web_server_1_id" {
  value = aws_instance.private_web_server_1.id
}

output "ami_private_web_server_2_id" {
  value = aws_instance.private_web_server_2.id
}

output "ami_public_web_server_id" {
  value = aws_instance.public_web_server.id
}

output "private_key" {
  value     = tls_private_key.project_private_key.private_key_pem
  sensitive = true
}

output "keypair_name" {
  value = aws_key_pair.project_keypair.key_name
}

output "private_sg_id" {
  value = aws_security_group.ec2_private_sg.id
}

output "public_sg_id" {
  value = aws_security_group.ec2_public_sg.id
}

# ✅ Additional Outputs for Public Instance
output "public_instance_public_ip" {
  value = aws_instance.public_web_server.public_ip
}

output "public_instance_private_ip" {
  value = aws_instance.public_web_server.private_ip
}

# ✅ Outputs for Private Instances
output "private_instance_1_private_ip" {
  value = aws_instance.private_web_server_1.private_ip
}

output "private_instance_2_private_ip" {
  value = aws_instance.private_web_server_2.private_ip
}
