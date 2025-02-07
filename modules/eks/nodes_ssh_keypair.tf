# =====================================================
# 🔹 SSH Key Pair for EKS Node Group
# =====================================================
# This Terraform configuration creates an RSA-based SSH key pair 
# for securely accessing EC2 instances in the EKS Node Group.
# The private key is stored locally, while the public key 
# is registered with AWS EC2.
# =====================================================

# 📌 Generate an RSA Private Key (2048-bit)
resource "tls_private_key" "node_group_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# 📌 Create an AWS EC2 Key Pair Using the Generated Public Key
resource "aws_key_pair" "node_group_keypair" {
  key_name   = "${var.EKS_NODE_GROUP_NAME}-keypair" # 🔹 Key pair named after the node group
  public_key = tls_private_key.node_group_private_key.public_key_openssh
}

# =====================================================
# 🛠️ Save the Private Key Locally
# =====================================================
# This ensures that the private key is securely stored 
# on the user's local machine for SSH access.
# =====================================================

resource "local_file" "node_group_private_key" {
  filename = "${path.root}/${var.EKS_NODE_GROUP_NAME}-keypair.pem" # 🔹 Store as PEM file
  content  = tls_private_key.node_group_private_key.private_key_pem
}
