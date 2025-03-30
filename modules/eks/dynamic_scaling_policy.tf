# =====================================================
# 🔄 Dynamic Scaling Policy for EKS Node Group
# =====================================================
# This file defines a dynamic scaling policy for an EKS node group.
# It uses a Target Tracking Scaling policy based on CPU utilization.
# =====================================================

# 🔍 Fetch Auto Scaling Group (ASG) associated with the EKS Node Group
data "aws_autoscaling_groups" "eks_nodegroup_asg" {
  filter {
    name   = "tag:eks:nodegroup-name"  # Filter ASG by EKS node group tag
    values = [var.EKS_NODE_GROUP_NAME] # Match the specific node group
  }
  depends_on = [aws_eks_node_group.project_eks_node_group] # Ensure the EKS node group is created first
}

# 📌 Extract the ASG Name Dynamically
locals {
  asg_name = length(data.aws_autoscaling_groups.eks_nodegroup_asg.names) > 0 ? data.aws_autoscaling_groups.eks_nodegroup_asg.names[0] : "" # Set ASG name or empty string if none found
}

# 🚀 Auto Scaling Policy for CPU Utilization
resource "aws_autoscaling_policy" "cpu_scaling" {
  name                      = "${var.EKS_CLUSTER_NAME}-cpu-utilization-scaling" # Naming based on cluster name
  autoscaling_group_name    = local.asg_name                                    # Attach the policy to the extracted ASG
  policy_type               = "TargetTrackingScaling"                           # Use Target Tracking Scaling Policy
  estimated_instance_warmup = 180                                               # Time (in seconds) for a new instance to warm up before scaling decisions

  # 📊 Target Tracking Configuration
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization" # Scale based on average CPU utilization
    }
    target_value = 50.0 # Scale up/down to maintain CPU utilization around 50%
  }

  # 🔄 Dependencies to Ensure Correct Execution Order
  depends_on = [
    data.aws_autoscaling_groups.eks_nodegroup_asg,
    aws_eks_node_group.project_eks_node_group
  ]
}
