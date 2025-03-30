# =====================================================
# 🔹 AWS Launch Template for EKS Worker Nodes
# =====================================================
# This Terraform configuration defines a launch template for 
# the EKS worker nodes, enabling EC2 instances to be provisioned 
# with the necessary configurations for integration with the EKS cluster.
# =====================================================

resource "aws_launch_template" "eks_launch_template" {
  name = "${var.EKS_CLUSTER_NAME}_launch_template" # 🔹 Naming based on EKS Cluster

  # =====================================================
  # 📌 Block Device Mapping (EBS Configuration)
  # =====================================================
  # This section defines the root volume (EBS) settings.
  block_device_mappings {
    device_name = "/dev/xvda" # 🔹 Default root volume device

    ebs {
      volume_size           = var.EKS_LAUNCH_TEMPLATE_VOLUME_SIZE # 🔹 Root volume size
      volume_type           = var.EKS_LAUNCH_TEMPLATE_VOLUME_TYPE # 🔹 Volume type (gp3, io1, etc.)
      delete_on_termination = true                                # 🔹 Delete EBS when instance terminates
    }
  }

  # =====================================================
  # 🚀 User Data for Bootstrapping Nodes
  # =====================================================
  # This section provides a base64-encoded MIME configuration file
  # that ensures the node is correctly configured to join the cluster.
  user_data = base64encode(<<EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.EKS_CLUSTER_NAME}
    apiServerEndpoint: ${aws_eks_cluster.project_eks.endpoint}
    certificateAuthority: ${aws_eks_cluster.project_eks.certificate_authority[0].data}
    cidr: ${aws_eks_cluster.project_eks.kubernetes_network_config[0].service_ipv4_cidr}
  kubelet:
    config:
      maxPods: 110
      clusterDNS:
      - ${cidrhost(aws_eks_cluster.project_eks.kubernetes_network_config[0].service_ipv4_cidr, 10)}
    flags:
    - "--node-labels=eks.amazonaws.com/nodegroup-image=${var.WORKER_NODE_AMI_ID},eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup=${var.EKS_NODE_GROUP_NAME}"

--BOUNDARY--
EOF
  )

  # =====================================================
  # 🔹 AMI & Instance Type Configuration
  # =====================================================
  image_id      = var.WORKER_NODE_AMI_ID                   # 🔹 AMI ID for worker nodes
  instance_type = var.EKS_LAUNCH_TEMPLATE_INSTANCE_TYPE    # 🔹 EC2 instance type for worker nodes
  key_name      = aws_key_pair.node_group_keypair.key_name # 🔹 SSH Key Pair for access

  # =====================================================
  # 🔐 Network Configuration
  # =====================================================
  network_interfaces {
    device_index    = 0                                         # 🔹 Primary network interface
    security_groups = [aws_security_group.eks_node_group_sg.id] # 🔹 Attach correct security group
  }

  # =====================================================
  # 📈 Enable CloudWatch Monitoring
  # =====================================================
  monitoring {
    enabled = var.EKS_NODES_DETAILED_MONITORING # 🔹 Enable detailed monitoring
  }

  # =====================================================
  # 🏷️ Tag Specifications
  # =====================================================
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                                = "Worker_Node"
      Terraform                                           = "True"
      "k8s.io/cluster-autoscaler/enabled"                 = "true"
      "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}"     = "owned"
      "k8s.io/cluster-autoscalar/${var.EKS_CLUSTER_NAME}" = "owned"
    }
  }

  # =====================================================
  # ⏳ Dependencies
  # =====================================================
  # Ensures that the EKS cluster and security groups are created 
  # before the launch template.
  depends_on = [
    aws_eks_cluster.project_eks,
    aws_security_group.eks_node_group_sg
  ]

  # =====================================================
  # 🏷️ Additional Tags for Launch Template
  # =====================================================
  tags = {
    Name      = "${var.EKS_CLUSTER_NAME}_launch_template"
    Terraform = "True"
  }
}
