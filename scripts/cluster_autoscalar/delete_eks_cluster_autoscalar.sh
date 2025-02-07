#!/bin/bash

# ===============================
# ⚡ Configuration Variables
# ===============================
PROJECT_NAME="project"                              # This should match with your project name in terraform
EKS_CLUSTER_NAME="your-eks-cluster"                 # Replace with actual EKS cluster name
AWS_REGION="us-east-1"                              # Replace with your AWS region
AWS_ACCOUNT_ID="123456789012"                       # Replace with your AWS Account ID

IAM_ROLE_NAME="eks-cluster-autoscaler"  # IAM Role assigned to Cluster Autoscaler
SERVICE_ACCOUNT_NAME="cluster-autoscaler"  # Kubernetes service account name
NAMESPACE="kube-system"  # Namespace where the autoscaler runs

# Retrieve OpenID Connect (OIDC) Provider URL for the EKS cluster
OIDC_URL="https://oidc.eks.${AWS_REGION}.amazonaws.com/id/$(aws eks describe-cluster --name $EKS_CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d'/' -f5)"

echo "⚠️ WARNING: This script will DELETE the Cluster Autoscaler resources in your EKS Cluster: $EKS_CLUSTER_NAME"
echo "🚀 Starting Cleanup Process..."

# ===============================
# Step 1️⃣: Delete Cluster Autoscaler Deployment
# ===============================
echo "🛑 Deleting Cluster Autoscaler Deployment and Related Resources..."
kubectl delete deployment cluster-autoscaler -n $NAMESPACE --ignore-not-found=true
kubectl delete serviceaccount $SERVICE_ACCOUNT_NAME -n $NAMESPACE --ignore-not-found=true
kubectl delete clusterrolebinding cluster-autoscaler --ignore-not-found=true
kubectl delete clusterrole cluster-autoscaler --ignore-not-found=true

echo "✅ Cluster Autoscaler Deployment Deleted"

# ===============================
# Step 2️⃣: Detach IAM Policies from Role
# ===============================
echo "🛑 Detaching IAM Policies from Role: $IAM_ROLE_NAME"
POLICIES=(
  "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
)

for policy in "${POLICIES[@]}"; do
  aws iam detach-role-policy --role-name $IAM_ROLE_NAME --policy-arn $policy
done

echo "✅ IAM Policies Detached"

# ===============================
# Step 3️⃣: Delete IAM Role
# ===============================
echo "🛑 Deleting IAM Role: $IAM_ROLE_NAME"
aws iam delete-role --role-name $IAM_ROLE_NAME
echo "✅ IAM Role Deleted"

# ===============================
# Step 4️⃣: Delete OIDC Provider (Optional)
# ===============================
echo "🔎 Checking if OIDC Provider exists..."
EXISTING_OIDC=$(aws iam list-open-id-connect-providers | grep "$OIDC_ID" || true)

if [ ! -z "$EXISTING_OIDC" ]; then
  echo "🛑 Deleting OIDC Provider: $OIDC_URL"
  PROVIDER_ARN="arn:aws:iam::$AWS_ACCOUNT_ID:oidc-provider/$OIDC_URL"
  aws iam delete-open-id-connect-provider --open-id-connect-provider-arn $PROVIDER_ARN
  echo "✅ OIDC Provider Deleted"
else
  echo "✅ OIDC Provider does not exist, skipping..."
fi

# ===============================
# 🎉 Final Verification Steps
# ===============================
echo "✅ Cleanup Complete! Verifying Remaining Resources..."
kubectl get pods -n kube-system | grep cluster-autoscaler || echo "✅ Cluster Autoscaler successfully removed"
aws iam list-roles | grep $IAM_ROLE_NAME || echo "✅ IAM Role successfully removed"

echo "🎉 All resources related to Cluster Autoscaler have been deleted!"
