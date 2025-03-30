#################################### PROJECT TITLE ####################################
# AWS provider variables to authenticate and deploy resources

variable "PROJECT_NAME" {
  description = "This is the name of the Project"
  type        = string
  default     = "Project"
}

#################################### PROVIDER ####################################
# AWS provider variables to authenticate and deploy resources

variable "AWS_ACCOUNT_NUMBER" {
  description = "This is the AWS Account Number"
  type        = string
}

variable "AWS_ACCESS_KEY" {
  description = "The AWS access key to deploy resources into"
  type        = string
}

variable "AWS_SECRET_KEY" {
  description = "The AWS secret key to deploy resources into"
  type        = string
}

variable "AWS_REGION" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1" # Default region set to US East (N. Virginia)
}

#################################### S3 ####################################
# S3 bucket configuration for frontend storage

variable "s3_frontend_bucket_name" {
  description = "Name of the S3 frontend bucket"
  type        = string
}

variable "s3_frontend_bucket_versioning" {
  description = "Enable or Disable versioning for S3 frontend bucket"
  type        = string
  default     = "Disabled" # Default versioning disabled
}

variable "s3_frontend_bucket_force_destroy" {
  description = "Enable or Disable force destroy for S3 frontend bucket"
  type        = bool
  default     = false # Default to false to prevent accidental deletion
}

variable "s3_frontend_bucket_object_lock" {
  description = "Enable or Disable object lock for S3 frontend bucket"
  type        = bool
  default     = false
}

#################################### ACM ####################################
# AWS Certificate Manager (ACM) for SSL/TLS certificates

variable "domain_name" {
  description = "Domain name of the project"
  type        = string
}

variable "validation_method" {
  description = "DNS validation method"
  type        = string
  default     = "DNS"
}

variable "acm_alternative_names" {
  description = "Alternative domain names of the project"
  type        = list(string)
  default     = []
}

#################################### ROUTE 53 ####################################
# Amazon Route 53 domain and DNS management

variable "r53_domain_name" {
  description = "Domain name of the project"
  type        = string
}

variable "r53_force_destroy" {
  description = "This will destroy all the records if enabled"
  type        = bool
  default     = false
}

###################################### OAC ########################################
# Origin Access Control settings for secure access to S3

variable "oac_type" {
  description = "Type of Origin Access Control"
  type        = string
  default     = "s3"
}

variable "oac_signing_behavior" {
  description = "Signing behavior for Origin Access Control"
  type        = string
  default     = "always"
}

variable "oac_signing_protocol" {
  description = "Signing protocol for Origin Access Control"
  type        = string
  default     = "sigv4"
}

#################################### CLOUDFRONT ####################################
# CloudFront settings for content delivery

variable "cf_enable" {
  description = "Enable or disable the CloudFront Distribution"
  type        = bool
  default     = true
}

variable "cf_ipv6" {
  description = "Enable IPv6 for CloudFront Distribution"
  type        = bool
  default     = true
}

variable "cf_root_object" {
  description = "Root object to redirect to (e.g., index.html)"
  type        = string
  default     = "index.html"
}

variable "cf_logs_bucket" {
  description = "Logs for this CloudFront Distribution will be stored in this bucket"
  type        = string
  default     = ""
}

variable "cf_cookies_enabled" {
  description = "Enable cookies support for CloudFront"
  type        = bool
  default     = false
}

variable "cf_aliases" {
  description = "List of alternative domain names"
  type        = list(string)
  default     = []
}

variable "cf_allowed_methods" {
  description = "Allowed HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cf_cached_methods" {
  description = "Cached HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cf_query_string" {
  description = "Enable forwarding of query strings"
  type        = bool
  default     = false
}

variable "cf_cookies_forward" {
  description = "Specify how cookies are forwarded"
  type        = string
  default     = "none"
}

variable "cf_viewer_protocol_policy" {
  description = "Viewer protocol policy (allow-all, https-only, redirect-to-https)"
  type        = string
  default     = "allow-all"
}

variable "cf_priceclass" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_All"
}

variable "cf_restriction_type" {
  description = "CloudFront geographic restriction type"
  type        = string
  default     = "none"
}

variable "cf_restricted_locations" {
  description = "List of restricted locations"
  type        = list(string)
  default     = []
}

variable "cf_default_certificate" {
  description = "Use default CloudFront SSL certificate"
  type        = bool
  default     = true
}

variable "cf_ssl_support_method" {
  description = "SSL support method"
  type        = string
  default     = "sni-only"
}

variable "cf_min_protocol_version" {
  description = "Minimum TLS protocol version"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "alias_record_domain" {
  description = "Primary alias domain for CloudFront"
  type        = string
}

variable "alternative_alias_record_domain" {
  description = "Alternative alias domain for CloudFront"
  type        = string
}

#################################### VPC ####################################
# Virtual Private Cloud (VPC) and subnet settings

variable "project_vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.0.0/20"
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.32.0/20"
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.16.0/20"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.48.0/20"
}

variable "ipv6_on_creation" {
  description = "Specify true to indicate that subnets should be assigned IPv6 addresses"
  type        = bool
  default     = false
}

variable "az_public_1" {
  description = "Availability Zone for public subnet 1"
  type        = string
}

variable "az_public_2" {
  description = "Availability Zone for public subnet 2"
  type        = string
}

variable "az_private_1" {
  description = "Availability Zone for private subnet 1"
  type        = string
}

variable "az_private_2" {
  description = "Availability Zone for private subnet 2"
  type        = string
}

#################################### EC2 #####################################
# EC2 instance configuration

variable "ec2_instance_name" {
  description = "Name for the EC2 instance"
  type        = string
  default     = "Project_Web_Server"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_keypair_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "Project_keypair"
}

variable "ec2_public_security_group_name" {
  description = "Public security group name for EC2"
  type        = string
  default     = "Project_EC2_Public_Security_Group"
}

variable "ec2_private_security_group_name" {
  description = "Private security group name for EC2"
  type        = string
  default     = "Project_EC2_Private_Security_Group"
}

variable "ec2_root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
}

variable "ec2_root_volume_type" {
  description = "Type of the root volume (e.g., gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "ec2_ebs_volume_size" {
  description = "Size of the additional EBS volume in GB"
  type        = number
  default     = 20
}

variable "ec2_ebs_volume_type" {
  description = "Type of the additional EBS volume (e.g., gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "ec2_ebs_device_name" {
  description = "Device name for the additional EBS volume"
  type        = string
  default     = "/dev/xvdf" # Default for Ubuntu (For storage types T2, T3, T4g, M5, C5, R5, etc.)
}

variable "ec2_ebs_iops" {
  description = "Provisioned IOPS for io1/io2 volumes"
  type        = number
  default     = 3000
}

variable "ec2_ebs_throughput" {
  description = "Throughput for gp3 volumes in MiBps"
  type        = number
  default     = 125
}

variable "ec2_ebs_encryted" {
  description = "Enable encryption for the additional EBS volume"
  type        = bool
  default     = true
}

variable "ec2_ebs_delete_on_termination" {
  description = "Whether to delete the additional EBS volume on instance termination"
  type        = bool
  default     = true
}

#################################### RDS ####################################
# Amazon RDS database settings
variable "db_name" {
  description = "Name for the RDS instance"
  type        = string
  default     = "my-db"
}

variable "db_instance_identifier" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "db_engine" {
  description = "Database engine (e.g., postgres, mysql)"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.m5.large"
}

variable "db_storage_size" {
  description = "Allocated storage for the RDS instance"
  type        = number
  default     = 22
}

variable "db_max_allocated_size" {
  description = "Maximum storage threshold for autoscaling"
  type        = number
  default     = 1000
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "db_storage_type" {
  description = "Storage type (gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}

variable "db_private_sg_name" {
  description = "Name of the security group for Database"
  type        = string
  default     = "Project_DB_Security_Group"
}

variable "db_iops" {
  description = "Provisioned IOPS for the database"
  type        = number
  default     = 3000
}

variable "db_storage_throughput" {
  description = "Storage throughput in MiBps"
  type        = number
  default     = 125
}

variable "db_backup_rentention_period" {
  description = "Number of days for automated backups retention"
  type        = number
  default     = 7
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Number of days for automated backups retention"
  type        = number
  default     = 7
}

variable "db_backup_window" {
  description = "Preferred backup window in UTC (e.g., 07:00-09:00)"
  type        = string
  default     = "03:00-05:00"
}

variable "db_copy_tags_to_snapshot" {
  description = "Copy tags to snapshots"
  type        = bool
  default     = true
}

variable "db_kms_key_id" {
  description = "KMS Key ID for encryption"
  type        = string
  default     = "alias/aws/rds"
}

variable "db_auto_minor_upgrade" {
  description = "Enable auto minor version upgrades"
  type        = bool
  default     = true
}

variable "db_publicly_accessible" {
  description = "Should the RDS instance have a public IP"
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "Protects the database from being deleted accidentally"
  type        = bool
  default     = false
}

variable "db_port" {
  description = "Port number for database connection"
  type        = number
  default     = 3306
}

variable "db_license_model" {
  description = "License model for the database (e.g., license-included)"
  type        = string
  default     = "license-included"
}

variable "db_subnet_group_name" {
  description = "RDS DB subnet group name"
  type        = string
}

variable "db_skip_final_snapshot" {
  description = "Skip the final snapshot of the DB instance if deleted"
  type        = bool
  default     = true
}

#################################### EKS #####################################
# Amazon Elastic Kubernetes Service (EKS) configuration

variable "eks_iam_cluster_role_name" {
  description = "Name for AWS EKS Cluster Role"
  type        = string
  default     = "project_EKS_IAM_Cluster_Role"
}

variable "eks_cluster_name" {
  description = "Name for AWS EKS Cluster"
  type        = string
  default     = "project_EKS_Cluster"
}

variable "eks_node_group_name" {
  description = "Name for AWS EKS Cluster Node Group"
  type        = string
  default     = "project_EKS_Node_group"
}

variable "eks_kubernetes_version" {
  description = "Kubernetes version for this cluster"
  type        = string
  default     = "1.31"
}

variable "eks_node_group_role_name" {
  description = "Name for AWS EKS Node Group Role"
  type        = string
  default     = "project_EKS_Node_Group_Role"
}

variable "eks_launch_template_volume_type" {
  description = "Type of the volume for EC2 worker nodes"
  type        = string
  default     = "gp3"
}

variable "eks_launch_template_instance_type" {
  description = "Instance type for EKS worker nodes"
  type        = string
  default     = "t2.micro"
}

variable "eks_launch_template_volume_size" {
  description = "Size of the EBS volume for worker nodes in GB"
  type        = number
  default     = 20
}

variable "eks_nodes_detailed_monitoring" {
  description = "Enable detailed monitoring for EKS nodes"
  type        = bool
  default     = false
}

variable "remove_old_policy" {
  description = "Flag to determine whether to remove old IAM policy"
  type        = bool
  default     = false
}

variable "eks_worker_node_ami_id" {
  description = "AMI ID used for worker nodes in the launch template"
  type        = string
  default     = "ami-005cb9eccb9a1b0f2"
}

variable "eks_addon_coredns_version" {
  description = "Version of CoreDNS add-on for EKS"
  type        = string
  default     = "v1.11.3-eksbuild.1" # Replace with the latest AWS recommended version
}

variable "eks_addon_kube_proxy_version" {
  description = "Version of Kube-proxy add-on for EKS"
  type        = string
  default     = "v1.31.2-eksbuild.3" # Replace with the latest AWS recommended version
}

variable "eks_addon_metric_server_version" {
  description = "Version of Metrics Server add-on for EKS"
  type        = string
  default     = "v0.7.2-eksbuild.1" # Replace with the latest AWS recommended version
}

variable "eks_addon_pod_identity_version" {
  description = "Version of Pod Identity Server add-on for EKS"
  type        = string
  default     = "v0.7.2-eksbuild.1" # Replace with the latest AWS recommended version
}

variable "eks_addon_vpc_cni_version" {
  description = "Version of Amazon VPC CNI add-on for EKS"
  type        = string
  default     = "v1.19.0-eksbuild.1" # Replace with the latest AWS recommended version
}

#################################### ECR #####################################
# Amazon Elastic Container Registry (ECR) settings

variable "ecr_repository_name" {
  description = "Name for ECR repository"
  type        = string
  default     = "Project_ECR_Repo"
}

variable "ecr_encryption_type" {
  description = "The encryption type to use for the repository"
  type        = string
  default     = "AES256"
}

variable "ecr_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = true
}

variable "ecr_image_scan" {
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)"
  type        = bool
  default     = false
}
