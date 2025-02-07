#!/bin/bash

# ===============================
# 🌚 Configuration Variables
# ===============================
PROJECT_NAME="project"                                                  # Replace with your Actual Project Name
AWS_REGION="us-east-1"                                                  # Replace with your AWS Region
EKS_CLUSTER_NAME="${PROJECT_NAME}_cluster"                              # Replace with your EKS cluster name
AWS_ACCOUNT_ID="123456789012"                                           # Replace with your AWS Account ID
LB_CONTROLLER_VERSION="v2.11.0"                                         # Load Balancer Controller version
CERT_MANAGER_CAINJECTOR="${PROJECT_NAME}_cert_manager_cainjector"       # ECR Repository for cert-manager-cainjector
CERT_MANAGER_CONTROLLER="${PROJECT_NAME}_cert_manager_controller"       # ECR Repository for cert-manager-controller
CERT_MANAGER_WEBHOOK="${PROJECT_NAME}_cert_manager_webhook"             # ECR Repository for cert-manager-webhook
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"    # ECR Registry

# ===============================
# 🔋 Delete Kubernetes Resources
# ===============================

# Delete cert-manager components
echo "🔹 Deleting cert-manager components..."
kubectl delete -f cert-manager.yaml --ignore-not-found

# Delete AWS Load Balancer Controller manifests
echo "🔹 Deleting AWS Load Balancer Controller manifests..."
kubectl delete -f v2_11_0_full.yaml --ignore-not-found
kubectl delete -f v2_11_0_ingclass.yaml --ignore-not-found

# Delete Service Account
echo "🔹 Deleting Service Account..."
kubectl delete serviceaccount aws-load-balancer-controller -n kube-system --ignore-not-found

# ===============================
# 🗑️ Delete IAM Resources
# ===============================

# Detach IAM policy from role
echo "🔹 Detaching IAM policy from role..."
aws iam detach-role-policy \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy || echo "Policy already detached."

# Delete IAM role
echo "🔹 Deleting IAM role..."
aws iam delete-role --role-name AmazonEKSLoadBalancerControllerRole || echo "Role already deleted."

# Delete IAM policy
echo "🔹 Deleting IAM policy..."
aws iam delete-policy --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy || echo "Policy already deleted."

# ===============================
# 🔧 Delete ECR Images and Repositories
# ===============================

# Function to delete all images in a repository
delete_ecr_images() {
  REPO_NAME=$1
  echo "🔹 Deleting images in ECR repository: ${REPO_NAME}..."
  IMAGE_TAGS=$(aws ecr list-images --repository-name ${REPO_NAME} --query 'imageIds[*]' --output json)
  if [[ "$IMAGE_TAGS" != "[]" ]]; then
    aws ecr batch-delete-image --repository-name ${REPO_NAME} --image-ids "$IMAGE_TAGS"
  fi
}

# Delete cert-manager images
delete_ecr_images ${CERT_MANAGER_CAINJECTOR}
delete_ecr_images ${CERT_MANAGER_CONTROLLER}
delete_ecr_images ${CERT_MANAGER_WEBHOOK}

# ===============================
# 📊 Final Status
# ===============================
echo "🌟 All resources related to AWS Load Balancer Controller and cert-manager have been deleted."

# Verify deletion
kubectl get pods -n cert-manager
kubectl get deployment -n kube-system aws-load-balancer-controller
aws iam list-roles | grep AmazonEKSLoadBalancerControllerRole
aws iam list-policies | grep AWSLoadBalancerControllerIAMPolicy
