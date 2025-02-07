# ================================
# 🔑 SSH Key Pair for EC2 Instances
# ================================

# Generate a new SSH private key
resource "tls_private_key" "project_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create an AWS Key Pair using the generated SSH key
resource "aws_key_pair" "project_keypair" {
  key_name   = var.KEY_PAIR_NAME
  public_key = tls_private_key.project_private_key.public_key_openssh
}

# Store the private key locally for secure SSH access
resource "local_file" "private_key" {
  filename = "${path.root}/${var.KEY_PAIR_NAME}.pem"
  content  = tls_private_key.project_private_key.private_key_pem
}
