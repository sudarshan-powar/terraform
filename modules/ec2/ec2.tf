# ================================
# 🖥️ EC2 Instance Deployment
# ================================

# 🔍 Fetch the latest Ubuntu AMI from AWS Marketplace
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's AWS account ID for official Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]  # Ensures we get a 64-bit AMI
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# ================================
# 🔹 Private EC2 Instances
# ================================

# Private Web Server 1
resource "aws_instance" "private_web_server_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.EC2_INSTANCE_TYPE
  key_name               = aws_key_pair.project_keypair.key_name
  subnet_id              = var.VPC_PRIVATE_SUBNET_ID_1
  vpc_security_group_ids = [aws_security_group.ec2_private_sg.id]

  root_block_device {
    volume_size           = var.ROOT_VOLUME_SIZE
    volume_type           = var.ROOT_VOLUME_TYPE
    delete_on_termination = true
  }

  tags = {
    Name      = "Private_${var.EC2_INSTANCE_NAME}_1"
    Terraform = "True"
  }

  depends_on = [aws_key_pair.project_keypair]
}

# Private Web Server 2
resource "aws_instance" "private_web_server_2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.EC2_INSTANCE_TYPE
  key_name               = aws_key_pair.project_keypair.key_name
  subnet_id              = var.VPC_PRIVATE_SUBNET_ID_2
  vpc_security_group_ids = [aws_security_group.ec2_private_sg.id]

  root_block_device {
    volume_size           = var.ROOT_VOLUME_SIZE
    volume_type           = var.ROOT_VOLUME_TYPE
    delete_on_termination = true
  }

  tags = {
    Name      = "Private_${var.EC2_INSTANCE_NAME}_2"
    Terraform = "True"
  }

  depends_on = [aws_key_pair.project_keypair]
}

# ================================
# 🌐 Public EC2 Instance
# ================================

resource "aws_instance" "public_web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.EC2_INSTANCE_TYPE
  key_name               = aws_key_pair.project_keypair.key_name
  subnet_id              = var.VPC_PUBLIC_SUBNET_ID_1
  vpc_security_group_ids = [aws_security_group.ec2_public_sg.id]

  root_block_device {
    volume_size           = var.ROOT_VOLUME_SIZE
    volume_type           = var.ROOT_VOLUME_TYPE
    delete_on_termination = true
  }
  # ebs_block_device {
  #   device_name = var.EBS_DEVICE_NAME  # Example: "/dev/sdf"
  #   volume_size = var.EBS_VOLUME_SIZE  # Additional EBS volume size in GB
  #   volume_type = var.EBS_VOLUME_TYPE  # gp2, gp3, io1, io2, etc.
  #   encrypted   = var.EBS_ENCRYPTED    # Enables encryption
  #   iops        = var.EBS_IOPS         # Only for io1/io2 volumes
  #   throughput  = var.EBS_THROUGHPUT   # Only for gp3 volumes
  #   delete_on_termination = var.EBS_DELETE_ON_TERMINATION                     # Uncomment if needed
  # }


  # 🛠️ SSH Key Transfer for Secure Access
  provisioner "file" {
    source      = "${path.root}/${var.KEY_PAIR_NAME}.pem"
    destination = "/home/ubuntu/${var.KEY_PAIR_NAME}.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.root}/${var.KEY_PAIR_NAME}.pem")
      host        = aws_instance.public_web_server.public_ip
    }
  }

  tags = {
    Name      = "Public_${var.EC2_INSTANCE_NAME}"
    Terraform = "True"
  }

  depends_on = [aws_key_pair.project_keypair]
}
