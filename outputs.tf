# ================================
# 📤 Terraform Outputs
# ================================
# This file defines the outputs of the Terraform modules.
# Outputs allow retrieving values from Terraform-managed resources 
# and using them outside Terraform, such as in CI/CD pipelines.

#################################### S3 ####################################

# The name of the frontend S3 bucket
output "s3_frontend_bucket_name" {
  value = module.s3_frontend_bucket.s3_frontend_bucket_name
}

# The ARN of the frontend S3 bucket
output "s3_frontend_bucket_arn" {
  value = module.s3_frontend_bucket.s3_frontend_bucket_arn
}

#################################### ACM (SSL/TLS Certificates) ####################################

# The ARN of the ACM (AWS Certificate Manager) SSL certificate
output "certificate_arn" {
  value = module.acm.certificate_arn
}

# The name of the domain for which the SSL certificate is issued
output "certificate_name" {
  value = module.acm.project_domain_name
}

#################################### Route 53 (DNS Management) ####################################

# The hosted zone ID in Route 53 for managing domain records
output "r53_hosted_zone_id" {
  value = module.hosted_zone.hosted_zone_id
}

# The ARN of the hosted zone
output "r53_hosted_zone_arn" {
  value = module.hosted_zone.hosted_zone_arn
}

#################################### OAC (Origin Access Control) #####################################

# The name of the Origin Access Control (OAC) associated with CloudFront and S3
output "oac_name" {
  value = module.oac.oac_name
}

#################################### CloudFront (CDN) ####################################

# The ID of the CloudFront distribution
output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_distribution_id
}

# The domain name of the CloudFront distribution
output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
}

#################################### VPC (Networking) ####################################

# The ID of the created VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

# Public and Private Subnet IDs
output "public_subnet_id_1" {
  value = module.vpc.public_subnet_id_1
}

output "public_subnet_id_2" {
  value = module.vpc.public_subnet_id_2
}

output "private_subnet_id_1" {
  value = module.vpc.private_subnet_id_1
}

output "private_subnet_id_2" {
  value = module.vpc.private_subnet_id_2
}

# Internet Gateway ID for public access
output "igw_id" {
  value = module.vpc.igw_id
}

# NAT Gateway ID for enabling internet access in private subnets
output "nat_gw_id" {
  value = module.vpc.nat_gw_id
}

#################################### EC2 (Compute Instances) ####################################

# AMI IDs for private web servers
output "ami_private_web_server_1_id" {
  value = module.ec2.ami_private_web_server_1_id
}

output "ami_private_web_server_2_id" {
  value = module.ec2.ami_private_web_server_2_id
}

# AMI ID for the public web server
output "ami_public_web_server_id" {
  value = module.ec2.ami_public_web_server_id
}

# The name of the EC2 Key Pair for SSH access
output "keypair_name" {
  value = module.ec2.keypair_name
}

# Security Groups for EC2 instances
output "private_sg" {
  value = module.ec2.private_sg_id
}

output "public_sg" {
  value = module.ec2.public_sg_id
}

# #################################### RDS (Relational Database) ####################################

# The database name
output "db_name" {
  value = module.project_rds.db_name
}

# The RDS instance identifier
output "db_instance_id" {
  value = module.project_rds.db_instance_id
}

# The ARN of the RDS instance
output "db_instance_arn" {
  value = module.project_rds.db_instance_arn
}

# Security Group for the RDS database
output "db_rds_sg_id" {
  value = module.project_rds.db_rds_sg_id
}

#################################### EKS (Kubernetes Cluster) ####################################

# IAM Role Name for the EKS Cluster
output "iam_cluster_role_name" {
  value = module.eks.iam_cluster_role_name
}

# The name of the EKS cluster
output "project_eks_cluster_name" {
  value = module.eks.iam_cluster_role_name # This seems incorrect, should it be module.eks.cluster_name?
}

#################################### ECR (Elastic Container Registry) ####################################

# The name of the ECR repository for storing container images
output "ecr_repo_name" {
  value = module.ecr.ecr_repo_name
}

# The ARN of the ECR repository
output "ecr_repo_arn" {
  value = module.ecr.ecr_repo_arn
}
