# =====================================================
# 🏗️ EC2 Module Input Variables
# =====================================================
# These variables define the configuration for EC2 instances, networking,
# security groups, and storage settings.
# =====================================================

# ================================
# 🖥️ EC2 Instance Configuration
# ================================

variable "EC2_INSTANCE_NAME" {
  description = "The name assigned to EC2 instances for identification."
  type        = string
  default     = "Project_Web_Server"
}

variable "EC2_INSTANCE_TYPE" {
  description = "The EC2 instance type to launch (e.g., t2.micro, t3.medium)."
  type        = string
  default     = "t2.micro"
}

variable "KEY_PAIR_NAME" {
  description = "The name of the SSH key pair to be used for EC2 access."
  type        = string
  default     = "Project_keypair"
}

# ================================
# 🌐 Network Configuration
# ================================

variable "VPC_ID" {
  description = "The ID of the Virtual Private Cloud (VPC) where EC2 instances will be launched."
  type        = string
}

variable "VPC_PUBLIC_SUBNET_ID_1" {
  description = "The first public subnet ID for EC2 deployment."
  type        = string
}

variable "VPC_PUBLIC_SUBNET_ID_2" {
  description = "The second public subnet ID for EC2 deployment."
  type        = string
}

variable "VPC_PRIVATE_SUBNET_ID_1" {
  description = "The first private subnet ID for EC2 deployment."
  type        = string
}

variable "VPC_PRIVATE_SUBNET_ID_2" {
  description = "The second private subnet ID for EC2 deployment."
  type        = string
}

# ================================
# 🔐 Security Group Configuration
# ================================

variable "EC2_PUBLIC_SECURITY_GROUP_NAME" {
  description = "The name of the security group for public-facing EC2 instances."
  type        = string
  default     = "Project_EC2_Public_SG"
}

variable "EC2_PRIVATE_SECURITY_GROUP_NAME" {
  description = "The name of the security group for private EC2 instances."
  type        = string
  default     = "Project_EC2_Private_SG"
}

# ================================
# 💾 Storage Configuration
# ================================

variable "ROOT_VOLUME_SIZE" {
  description = "The size (in GB) of the root volume attached to EC2 instances."
  type        = number
  default     = 8
}

variable "ROOT_VOLUME_TYPE" {
  description = "The type of the root volume (e.g., gp2, gp3, io1, io2)."
  type        = string
  default     = "gp3"
}

variable "EBS_VOLUME_SIZE" {
  description = "The size (in GB) of the additional EBS volume attached to EC2 instances."
  type        = number
  default     = 20
}

variable "EBS_VOLUME_TYPE" {
  description = "The type of the additional EBS volume (e.g., gp2, gp3, io1, io2)."
  type        = string
  default     = "gp3"
}

variable "EBS_DEVICE_NAME" {
  description = "Device name for the additional EBS volume"
  type        = string
  default     = "/dev/xvdf" # Default for Ubuntu (For storage types T2, T3, T4g, M5, C5, R5, etc.)
}

variable "EBS_IOPS" {
  description = "Provisioned IOPS for io1/io2 volumes"
  type        = number
  default     = 3000
}

variable "EBS_THROUGHPUT" {
  description = "Throughput for gp3 volumes in MiBps"
  type        = number
  default     = 125
}

variable "EBS_ENCRYPTED" {
  description = "Enable encryption for the additional EBS volume"
  type        = bool
  default     = true
}

variable "EBS_DELETE_ON_TERMINATION" {
  description = "Whether to delete the additional EBS volume on instance termination"
  type        = bool
  default     = true
}