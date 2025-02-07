
# Terraform Infrastructure Deployment

This project contains Terraform configurations to automate the deployment and management of infrastructure resources.

## Project Structure

```
terraform/
├── main.tf                # Core infrastructure configuration
├── variables.tf           # Input variables definitions
├── outputs.tf             # Outputs after infrastructure deployment
├── provider.tf            # Provider configurations (e.g., AWS, Azure)
├── terraform.tfvars       # Variable values (ensure sensitive data is excluded)
├── scripts/               # Custom scripts used in provisioning
├── modules/               # Reusable Terraform modules
├── example/               # Sample application for testing deployments
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v5.8x or higher
- Cloud provider CLI (AWS) configured with appropriate credentials

Modules Overview

### VPC Module
```
│   ├── vpc/                         # VPC Module
│   │   ├── vpc.tf                   # Defines the core VPC resource
│   │   ├── public_subnets.tf        # Configures public subnets for internet-facing resources
│   │   ├── private_subnets.tf       # Configures private subnets for internal resources
│   │   ├── private_route_table.tf   # Defines route tables for private subnet traffic
│   │   ├── public_route_table.tf    # Defines route tables for public subnet traffic
│   │   ├── variables.tf             # Parameterizes VPC configurations
│   │   ├── outputs.tf               # Outputs VPC IDs and subnet details
```
The VPC Module sets up the networking foundation by creating a Virtual Private Cloud (VPC) with both public and private subnets. Public subnets are configured to route traffic through an Internet Gateway, making them accessible from the internet, while private subnets use a NAT Gateway for secure outbound traffic without direct internet exposure. Route tables are configured separately for public and private traffic, ensuring secure data flow. This VPC acts as the backbone for other modules like EC2, EKS, and RDS, providing isolated and secure networking environments.

### EC2 Module
```
│   ├── ec2/                          # EC2 Module
│   │   ├── ec2.tf                    # Provisions EC2 instances
│   │   ├── ec2_security_group.tf     # Configures security groups for EC2 instances
│   │   ├── ssh_keypair.tf            # Generates SSH Key Pair for secure instance access
│   │   ├── variables.tf              # Parameterizes EC2 configurations
│   │   ├── outputs.tf                # Outputs instance IDs and public IPs
```
The EC2 Module provisions compute instances within the public subnets of the VPC. These instances are typically used for hosting applications, running scripts, or serving as bastion hosts for accessing private resources. The ec2_security_group.tf file secures the instances by defining inbound and outbound rules. SSH access is managed using key pairs defined in ssh_keypair.tf, ensuring secure connectivity. The instances can interact with internet-facing services like the Application Load Balancer (ALB) for efficient traffic management.

### EKS Module
```
│   ├── eks/                                   # EKS Module
│   │   ├── eks_cluster.tf                     # Sets up the EKS control plane
│   │   ├── node_group.tf                      # Configures worker node groups
│   │   ├── launch_template.tf                 # Defines launch templates for nodes
│   │   ├── dynamic_scaling_policy.tf          # Configures auto-scaling policies
│   │   ├── cluster_main_security_group.tf     # Security group for the EKS control plane
│   │   ├── node_group_security_group.tf       # Security group for worker nodes
│   │   ├── IAM_cluster_role.tf                # IAM role for the EKS cluster
│   │   ├── node_group_role.tf                 # IAM role for node groups
│   │   ├── vpc_cni_role.tf                    # IAM role for VPC CNI plugin
│   │   ├── EKS_addons.tf                      # Defines EKS addons (e.g., CoreDNS, kube-proxy)
│   │   ├── ssh_keypair.tf                     # SSH Key Pair for accessing worker nodes
│   │   ├── outputs.tf                         # Outputs EKS cluster details
│   │   ├── variables.tf                       # Parameterizes EKS configurations
```
The EKS Module deploys an Elastic Kubernetes Service (EKS) cluster in the private subnets of the VPC. It sets up the control plane (eks_cluster.tf), worker nodes (node_group.tf), and integrates with IAM roles (IAM_cluster_role.tf and node_group_role.tf) for secure access. The module configures security groups (cluster_main_security_group.tf and node_group_security_group.tf) to restrict traffic to trusted sources. The EKS cluster is connected to the ALB for managing external traffic to containerized applications. The module also supports dynamic auto-scaling (dynamic_scaling_policy.tf) and integrates with CloudWatch for monitoring.

### RDS Module
```
│   ├── rds/                         # RDS Module
│   │   ├── rds.tf                   # Provisions RDS instances
│   │   ├── rds_security_group.tf    # Configures security groups for RDS
│   │   ├── variables.tf             # Parameterizes RDS configurations
│   │   ├── outputs.tf               # Outputs database endpoints and details
```
The RDS Module provisions a managed relational database service within the VPC’s private subnets. It supports various database engines like PostgreSQL and MySQL (rds.tf). Security groups (rds_security_group.tf) ensure that only authorized applications can connect to the database. The RDS instances are secured and isolated, with access controlled via IAM policies. Applications running on EC2 or EKS securely connect to the RDS instance through the VPC’s private networking.

### S3 Module
```
│   ├── s3/                          # S3 Module
│   │   ├── s3.tf                    # Creates S3 buckets for storage
│   │   ├── s3_bucket_policy.tf      # Defines bucket policies for security
│   │   ├── variables.tf             # Parameterizes S3 configurations
│   │   ├── outputs.tf               # Outputs S3 bucket URLs
```
The S3 Module creates a storage bucket for static assets, such as frontend application files. The bucket (s3.tf) is configured for static website hosting and integrates with CloudFront for optimized content delivery. The s3_bucket_policy.tf defines access permissions, ensuring that the bucket is accessible only through CloudFront, which acts as a Content Delivery Network (CDN).

### CloudFront Module
```
│   ├── cloudfront/                # CloudFront Module
│   │   ├── cloudfront.tf          # Configures CloudFront distributions
│   │   ├── route53_record.tf      # Sets up DNS alias records in Route 53
│   │   ├── variables.tf           # Parameterizes CloudFront configurations
│   │   ├── outputs.tf             # Outputs CloudFront distribution domains
```
The CloudFront Module sets up a CDN to deliver static content from the S3 bucket with low latency. It integrates with the ACM Module for securing content delivery using HTTPS. The route53_record.tf links CloudFront distributions to custom domains managed in Route 53, ensuring fast and secure content delivery to users worldwide.

### Route 53 Module
```
│   ├── route53/                # Route 53 Module
│   │   ├── route53.tf          # Manages DNS records and hosted zones
│   │   ├── variables.tf        # Parameterizes Route 53 configurations
│   │   ├── outputs.tf          # Outputs hosted zone details
```
The Route 53 Module manages DNS configurations and hosted zones. It creates alias records (route53.tf) to route traffic to CloudFront distributions, ALBs, and other AWS services. This module ensures seamless domain management and integrates with ACM for securing domain communications.

### ACM Module
```
│   ├── acm/                # ACM Certificate Module
│   │   ├── acm.tf          # Provisions SSL/TLS certificates
│   │   ├── variables.tf    # Parameterizes ACM configurations
│   │   ├── outputs.tf      # Outputs certificate ARNs
```
The ACM Module provisions SSL/TLS certificates (acm.tf) for securing communications across AWS services. It integrates with CloudFront, ALB, and Route 53 to ensure all external traffic is encrypted and secure.

### ECR Module
```
│   ├── ecr/                # Elastic Container Registry Module
│   │   ├── ecr.tf          # Sets up ECR repositories
│   │   ├── cert_manager.tf # Configures DNS alias records for ECR in Route 53
│   │   ├── variables.tf    # Parameterizes ECR configurations
│   │   ├── outputs.tf      # Outputs ECR repository URLs
```
The ECR Module sets up Elastic Container Registry (ecr.tf) for storing Docker images. These images are used by the EKS Module to deploy containerized applications. The cert_manager.tf ensures secure DNS configurations via Route 53. The ECR integrates with IAM for secure access and with CloudWatch for monitoring image usage.

### OAC Module
```
│   ├── oac/                # Origin Access Control Module
│   │   ├── oac.tf          # Configures Origin Access Control settings
│   │   ├── variables.tf    # Parameterizes OAC configurations
│   │   ├── outputs.tf      # Outputs OAC settings
```
The OAC Module configures Origin Access Control settings (oac.tf) for CloudFront distributions, ensuring that only CloudFront can access the S3 bucket directly. This enhances security by preventing unauthorized access to stored content.

# Resource Interconnection

Each module in this Terraform setup is interconnected to build a cohesive and secure infrastructure:

The VPC Module forms the networking base, connecting all other resources within secure subnets.

EC2 instances and EKS clusters rely on the VPC for networking and are managed externally through the ALB.

RDS databases reside in private subnets, with secure access from EC2 and EKS.

The S3 Module stores static assets, served globally via CloudFront, which is managed through Route 53 for custom domains.

IAM ensures all resources have secure, least-privilege access.

ACM provides SSL certificates for secure data transfer across CloudFront and ALB.

ECR integrates with EKS for containerized application deployments.

CloudWatch monitors all resources, providing centralized logging and metrics.

OAC secures the S3 bucket, allowing access only through CloudFront.

This architecture ensures high availability, security, and scalability, making it suitable for production-grade deployments.

More modules to be added in future.


## Backend Configuration (S3)

To manage the Terraform state remotely, configure an S3 bucket as the backend in your `provider.tf` file:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"
    key            = "path/to/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "your-dynamodb-lock-table"
    encrypt        = true
  }
}
```

### Steps to Set Up S3 Backend

1. **Create an S3 bucket:**
   ```bash
   aws s3api create-bucket --bucket your-s3-bucket-name --region us-west-2
   ```

2. **Enable versioning on the bucket:**
   ```bash
   aws s3api put-bucket-versioning --bucket your-s3-bucket-name --versioning-configuration Status=Enabled
   ```

3. **Create a DynamoDB table for state locking:**
   ```bash
   aws dynamodb create-table \
     --table-name your-dynamodb-lock-table \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
   ```
4. **Navigate to Your Terraform Directory**

Move to the directory containing your Terraform configuration files.
```bash
cd terraform
```
5. **Initialize Terraform**

This command initializes your Terraform environment and configures the S3 backend.
```bash
terraform init
```
6. **Format and Validate Your Terraform Configuration**

Ensure that your configuration files are properly formatted and free from syntax errors.
```bash
terraform fmt
terraform validate
```
7. **Plan the Terraform Deployment**

Generate an execution plan to review changes before applying.
```bash
terraform plan -out=plan.out
```
8. **Apply the Terraform Configuration**

Apply the planned changes to provision your infrastructure.
```bash
terraform apply plan.out
```
9. **Destroy the Infrastructure (When Needed)**

To tear down the infrastructure, use the destroy command.
```bash
terraform destroy
```
By following these steps, you can securely manage your Terraform state using S3 and ensure consistent deployments with DynamoDB state locking.


# Getting Started

0. **Don't worry at all. All you need to take care of is `terraform.tfvars.example` and `scripts/` at the end.**

1. **`terraform.tfvars.example`** is a ready-to-implement file. Copy it to `terraform.tfvars` and fill in your specific values.

2. **If you don't want to implement a specific module**, comment out that module in `terraform.tfvars`, `main.tf`, and `outputs.tf`.

3. **For databases,** if you're using **MS SQL Server**, comment out the `db_name` as it is not required.

4. **Post Deployment:** Once Terraform is applied successfully and if you've deployed **EKS** using Terraform:
   - Run `alb_controller.sh` to deploy the ALB Controller to EKS.
   - Run `cluster_autoscalar.sh` to deploy the Cluster Autoscaler for your EKS from the `scripts/` folder.

5. **Testing:** To test everything:
   - Deploy the sample application from the `example/` folder.
   - If you're using both deployments, try **path-based routing** and **host-based routing**.
   - To implement this, add the **ALB DNS** to your Route 53 Hosted Zone as an **Alias Record**.

## Applying the Configuration

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd terraform
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Format and Validate the Code:**
   ```bash
   terraform fmt
   terraform validate
   ```

4. **Plan the Deployment:**
   ```bash
   terraform plan -out=plan.out
   ```

5. **Apply the Configuration:**
   ```bash
   terraform apply plan.out
   ```

6. **Destroy the Infrastructure (when needed):**
   ```bash
   terraform destroy
   ```

## Variables

Define variable values in `terraform.tfvars` or pass them via the command line:

```hcl
# Example variables
AWS_REGION = "us-east-1"
ec2_instance_type = "t2.micro"
```

## Outputs

After successful deployment, Terraform will output relevant information defined in `outputs.tf`, such as resource IDs, IP addresses, etc.

## Best Practices

- **Sensitive Data:** Do not commit sensitive information. Use environment variables or secret managers.
- **State Management:** Use remote state storage (e.g., S3 with DynamoDB locking) for team environments.
- **Version Control:** Exclude files like `terraform.tfstate`, `plan.out`, and `.terraform/` from version control.

---

**More modules to be added in future.**

## License

This project is licensed under the [MIT License](LICENSE).
