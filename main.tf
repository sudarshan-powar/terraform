# =====================================================
# 🚀 Terraform Main Configuration
# =====================================================
# This file defines all the Terraform modules used in the project.
# It manages:
# - S3 for frontend hosting
# - ACM for SSL certificates
# - Route 53 for DNS management
# - CloudFront for CDN distribution
# - VPC for networking
# - EC2 instances for compute resources
# - RDS for database hosting
# - EKS for Kubernetes cluster
# - ECR for container registry
# =====================================================

#################################### S3 BUCKET ####################################

# ✅ S3 Bucket for Frontend Hosting
module "s3_frontend_bucket" {
  source = "./modules/s3"

  S3_FRONTEND_BUCKET               = var.s3_frontend_bucket_name
  S3_FRONTEND_BUCKET_VERSIONING    = var.s3_frontend_bucket_versioning
  S3_FRONTEND_BUCKET_FORCE_DESTROY = var.s3_frontend_bucket_force_destroy
  S3_FRONTEND_BUCKET_OBJECT_LOCK   = var.s3_frontend_bucket_object_lock
  CLOUDFRONT_DISTRIBUTION_ARN      = module.cloudfront.cloudfront_domain_arn
}

#################################### ACM (SSL CERTIFICATES) ####################################

# ✅ AWS Certificate Manager (ACM) for SSL
module "acm" {
  source = "./modules/acm"

  DOMAIN_NAME        = var.domain_name
  ALTERNATIVE_NAMES  = var.acm_alternative_names
  VALIDATION_METHOD  = var.validation_method
  R53_HOSTED_ZONE_ID = module.hosted_zone.hosted_zone_id

  depends_on = [module.hosted_zone]
}

#################################### ROUTE 53 (DNS MANAGEMENT) ####################################

# ✅ AWS Route 53 for DNS Hosting
module "hosted_zone" {
  source = "./modules/route53"

  DOMAIN_NAME   = var.r53_domain_name
  FORCE_DESTROY = var.r53_force_destroy
}

#################################### OAC (Origin Access Control) ####################################

# ✅ CloudFront Origin Access Control (OAC)
module "oac" {
  source = "./modules/oac"

  ORIGIN_ACCESS_CONTROL_NAME = module.s3_frontend_bucket.s3_frontend_bucket_name
  OAC_TYPE                   = var.oac_type
  OAC_SIGNING_BEHAVIOR       = var.oac_signing_behavior
  OAC_SIGNING_PROTOCOL       = var.oac_signing_protocol
}

#################################### CLOUDFRONT (CDN) ####################################

# ✅ Amazon CloudFront Distribution
module "cloudfront" {
  source = "./modules/cloudfront"

  ORIGIN_DOMAIN_NAME             = module.s3_frontend_bucket.s3_frontend_bucket_domain
  ORIGIN_ACCESS_CONTROL_ID       = module.oac.oac_id
  ORIGIN_ID                      = module.s3_frontend_bucket.s3_frontend_bucket_id
  CLOUDFRONT_ENABLE              = var.cf_enable
  CLOUDFRONT_IPV6                = var.cf_ipv6
  CLOUDFRONT_DEFAULT_ROOT_OBJECT = var.cf_root_object
  CLOUDFRONT_LOGS_BUCKET         = var.cf_logs_bucket
  #CLOUDFRONT_COOKIES_ENABLED = var.cf_cookies_enabled          # Uncomment if needed
  CLOUDFRONT_ALIASES              = var.cf_aliases
  CLOUDFRONT_ALLOWED_METHODS      = var.cf_allowed_methods
  CLOUDFRONT_CACHED_METHODS       = var.cf_cached_methods
  CLOUDFRONT_QUERY_STRING         = var.cf_query_string
  CLOUDFRONT_COOKIES_FORWARD      = var.cf_cookies_forward
  VIEWER_PROTOCOL_POLICY          = var.cf_viewer_protocol_policy
  CLOUDFRONT_PRICECLASS           = var.cf_priceclass
  RESTRICTED_LOCATIONS            = var.cf_restricted_locations
  RESTRICTION_TYPE                = var.cf_restriction_type
  ACM_CERTIFICATE_ARN             = module.acm.certificate_arn
  SSL_SUPPORT_METHOD              = var.cf_ssl_support_method
  MIN_PROTOCOL_VERSION            = var.cf_min_protocol_version
  ALIAS_RECORD_DOMAIN             = var.alias_record_domain
  ALTERNATIVE_ALIAS_RECORD_DOMAIN = var.alternative_alias_record_domain
  HOSTED_ZONE_ID                  = module.hosted_zone.hosted_zone_id

  depends_on = [module.oac]
}

#################################### VPC (NETWORKING) ####################################

# ✅ Amazon VPC for Networking
module "vpc" {
  source = "./modules/vpc"

  PROJECT_VPC_NAME      = var.project_vpc_name
  VPC_CIDR_BLOCK        = var.vpc_cidr_block
  PUBLIC_SUBNET_CIDR_1  = var.public_subnet_cidr_1
  PUBLIC_SUBNET_CIDR_2  = var.public_subnet_cidr_2
  PRIVATE_SUBNET_CIDR_1 = var.private_subnet_cidr_1
  PRIVATE_SUBNET_CIDR_2 = var.private_subnet_cidr_2
  IPV6_ON_CREATION      = var.ipv6_on_creation
  AZ_PRIVATE_1          = var.az_private_1
  AZ_PRIVATE_2          = var.az_private_2
  AZ_PUBLIC_1           = var.az_public_1
  AZ_PUBLIC_2           = var.az_public_2
}

#################################### EC2 (COMPUTE INSTANCES) ####################################

# ✅ Amazon EC2 Instances
module "ec2" {
  source = "./modules/ec2"

  EC2_INSTANCE_NAME               = var.ec2_instance_name
  EC2_INSTANCE_TYPE               = var.ec2_instance_type
  KEY_PAIR_NAME                   = var.ec2_keypair_name
  VPC_ID                          = module.vpc.vpc_id
  VPC_PUBLIC_SUBNET_ID_1          = module.vpc.public_subnet_id_1
  VPC_PUBLIC_SUBNET_ID_2          = module.vpc.public_subnet_id_2
  VPC_PRIVATE_SUBNET_ID_1         = module.vpc.private_subnet_id_1
  VPC_PRIVATE_SUBNET_ID_2         = module.vpc.private_subnet_id_2
  EC2_PRIVATE_SECURITY_GROUP_NAME = var.ec2_private_security_group_name
  EC2_PUBLIC_SECURITY_GROUP_NAME  = var.ec2_public_security_group_name
  ROOT_VOLUME_SIZE                = var.ec2_root_volume_size
  ROOT_VOLUME_TYPE                = var.ec2_root_volume_type
  EBS_VOLUME_SIZE                 = var.ec2_ebs_volume_size
  EBS_VOLUME_TYPE                 = var.ec2_ebs_volume_type
}

#################################### RDS (DATABASE) ####################################

# # ✅ Amazon RDS Database Instance
module "project_rds" {
  source                = "./modules/rds"
  DB_STORAGE_SIZE       = var.db_storage_size
  MAX_ALLOCATED_STORAGE = var.db_max_allocated_size
  # ✅ If you're using MS SQL Server, there is no need for a DB_Name

  DB_NAME                        = var.db_name # Uncomment if needed
  DB_ENGINE                      = var.db_engine
  ENGINE_VERSION                 = var.db_engine_version
  DB_INSTANCE_CLASS              = var.db_instance_class
  DB_INSTANCE_IDENTIFIER         = var.db_instance_identifier
  DB_USERNAME                    = var.db_username
  DB_PASSWORD                    = var.db_password
  STORAGE_TYPE                   = var.db_storage_type
  IOPS                           = var.db_iops
  STORAGE_THROUGHPUT             = var.db_storage_throughput
  MULTI_AZ                       = var.db_multi_az
  VPC_ID                         = module.vpc.vpc_id
  EC2_PRIVATE_SECURITY_GROUP_ID  = module.ec2.private_sg_id
  DB_SUBNET_PRIVATE_1            = module.vpc.private_subnet_id_1
  DB_SUBNET_PRIVATE_2            = module.vpc.private_subnet_id_2
  DB_PRIVATE_SECURITY_GROUP_NAME = var.db_private_sg_name
  DB_SKIP_FINAL_SNAPSHOT         = var.db_skip_final_snapshot
  DB_PORT                        = var.db_port
  PUBLICLY_ACCESSIBLE            = var.db_publicly_accessible
  BACKUP_RETENTION_PERIOD        = var.db_backup_rentention_period
  BACKUP_WINDOW                  = var.db_backup_window
  AUTO_MINOR_VERSION_UPGRADE     = var.db_auto_minor_upgrade
  DB_DELETION_PROTECTION         = var.db_deletion_protection
  DB_LICENSE_MODEL               = var.db_license_model

  depends_on = [module.vpc]
}

#################################### EKS (KUBERNETES CLUSTER) ####################################

# ✅ Amazon EKS Cluster
module "eks" {
  source = "./modules/eks"

  IAM_CLUSTER_ROLE_NAME             = var.eks_iam_cluster_role_name
  EKS_CLUSTER_NAME                  = var.eks_cluster_name
  PUBLIC_SERVER_SECURITY_GROUP      = module.ec2.public_sg_id
  EKS_NODE_GROUP_NAME               = var.eks_node_group_name
  EKS_NODE_GROUP_ROLE_NAME          = var.eks_node_group_role_name
  KUBERNETES_VERSION                = var.eks_kubernetes_version
  VPC_ID                            = module.vpc.vpc_id
  VPC_PRIVATE_SUBNET_ID_1           = module.vpc.private_subnet_id_1
  VPC_PRIVATE_SUBNET_ID_2           = module.vpc.private_subnet_id_2
  VPC_PUBLIC_SUBNET_ID_1            = module.vpc.public_subnet_id_1
  VPC_PUBLIC_SUBNET_ID_2            = module.vpc.public_subnet_id_2
  EKS_LAUNCH_TEMPLATE_INSTANCE_TYPE = var.eks_launch_template_instance_type
  EKS_LAUNCH_TEMPLATE_VOLUME_SIZE   = var.eks_launch_template_volume_size
  EKS_LAUNCH_TEMPLATE_VOLUME_TYPE   = var.eks_launch_template_volume_type
  EKS_NODES_DETAILED_MONITORING     = var.eks_nodes_detailed_monitoring
  REMOVE_OLD_POLICY                 = var.remove_old_policy
  WORKER_NODE_AMI_ID                = var.eks_worker_node_ami_id
  AWS_REGION                        = var.AWS_REGION
  EKS_COREDNS_VERSION               = var.eks_addon_coredns_version
  EKS_KUBE_PROXY_VERSION            = var.eks_addon_kube_proxy_version
  EKS_METRICS_SERVER_VERSION        = var.eks_addon_metric_server_version
  #EKS_POD_IDENTITY_VERSION = var.eks_addon_pod_identity_version        # Uncomment if needed
  EKS_VPC_CNI_VERSION = var.eks_addon_vpc_cni_version

  depends_on = [module.vpc]
}

#################################### ECR (CONTAINER REGISTRY) ####################################

# ✅ Amazon Elastic Container Registry (ECR)
module "ecr" {
  source              = "./modules/ecr"
  PROJECT_NAME        = var.PROJECT_NAME
  ECR_REPOSITORY_NAME = var.ecr_repository_name
  ENCRYPTION_TYPE     = var.ecr_encryption_type
  MUTABILITY          = var.ecr_mutability
  FORCE_DELETE        = var.ecr_force_delete
  IMAGE_SCAN          = var.ecr_image_scan
}
