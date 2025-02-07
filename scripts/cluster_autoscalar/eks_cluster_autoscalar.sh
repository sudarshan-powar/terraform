#!/bin/bash

# ===============================
# ⚡ Configuration Variables
# ===============================
PROJECT_NAME="project"                                  # This should match with your project name in terraform
EKS_CLUSTER_NAME="${PROJECT_NAME}_cluster"              # Replace with actual EKS cluster name
AWS_REGION="us-east-1"                                  # Replace with your AWS region
AWS_ACCOUNT_ID="123456789012"                            # Replace with your AWS Account ID

IAM_ROLE_NAME="eks-cluster-autoscaler"                  # IAM Role assigned to Cluster Autoscaler
SERVICE_ACCOUNT_NAME="cluster-autoscaler"               # Kubernetes service account name
NAMESPACE="kube-system"                                 # Namespace where the autoscaler runs

# Retrieve OpenID Connect (OIDC) Provider URL for the EKS cluster
OIDC_URL="https://oidc.eks.${AWS_REGION}.amazonaws.com/id/$(aws eks describe-cluster --name $EKS_CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d'/' -f5)"

echo "Setting up Cluster Autoscaler for EKS Cluster: $EKS_CLUSTER_NAME"

# ===============================
# Step 1️⃣: Enable OIDC Provider
# ===============================
echo "🔹 Checking if OIDC provider exists..."
OIDC_ID=$(echo $OIDC_URL | cut -d'/' -f5)
EXISTING_OIDC=$(aws iam list-open-id-connect-providers | grep "$OIDC_ID" || true)

if [ -z "$EXISTING_OIDC" ]; then
  echo "✅ Creating OIDC Provider..."
  aws iam create-open-id-connect-provider \
    --url $OIDC_URL \
    --client-id-list "sts.amazonaws.com" \
    --thumbprint-list "9e99a48a9960b14926bb7f3b02e22da2b0ec0445"
else
  echo "✅ OIDC Provider already exists, skipping creation."
fi

# ===============================
# Step 2️⃣: Create IAM Role for Cluster Autoscaler
# ===============================
echo "🔹 Creating IAM Role for Cluster Autoscaler..."

aws iam create-role --role-name $IAM_ROLE_NAME --assume-role-policy-document "{
  \"Version\": \"2012-10-17\",
  \"Statement\": [
    {
      \"Effect\": \"Allow\",
      \"Principal\": {
        \"Federated\": \"arn:aws:iam::$AWS_ACCOUNT_ID:oidc-provider/oidc.eks.$AWS_REGION.amazonaws.com/id/$OIDC_ID\"
      },
      \"Action\": \"sts:AssumeRoleWithWebIdentity\",
      \"Condition\": {
        \"StringEquals\": {
          \"oidc.eks.$AWS_REGION.amazonaws.com/id/$OIDC_ID:sub\": \"system:serviceaccount:$NAMESPACE:$SERVICE_ACCOUNT_NAME\"
        }
      }
    }
  ]
}"
echo "✅ IAM Role Created: $IAM_ROLE_NAME"


# ===============================
# Step 3️⃣: Attach Required Policies
# ===============================
echo "🔹 Attaching required policies..."
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AutoScalingFullAccess
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess
echo "✅ Policies Attached to IAM Role"

# ===============================
# Step 4️⃣: Create Kubernetes Service Account with IAM Role
# ===============================
echo "🔹 Creating Kubernetes Service Account..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $SERVICE_ACCOUNT_NAME
  namespace: $NAMESPACE
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::$AWS_ACCOUNT_ID:role/$IAM_ROLE_NAME
EOF
echo "✅ Service Account Created: $SERVICE_ACCOUNT_NAME"

# ===============================
# Step 5️⃣: Download and Modify Cluster Autoscaler YAML
# ===============================
echo "🔹 Downloading and modifying Cluster Autoscaler YAML..."
curl -o cluster-autoscaler.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

# Replace placeholder with actual cluster name
sed -i '' "s/<YOUR CLUSTER NAME>/$EKS_CLUSTER_NAME/g" cluster-autoscaler.yaml

# Apply the modified file
kubectl apply -f cluster-autoscaler.yaml
echo "✅ Cluster Autoscaler Deployed"

# ===============================
# Step 6️⃣: Add RBAC Permissions
# ===============================
echo "🔹 Applying RBAC Permissions..."
kubectl annotate deployment cluster-autoscaler -n kube-system cluster-autoscaler.kubernetes.io/safe-to-evict="false"
echo "✅ RBAC Permissions Applied"

# ===============================
# 🎉 Final Verification Steps
# ===============================
echo "✅ Setup Complete! Verifying Deployment..."
kubectl get pods -n kube-system | grep cluster-autoscaler
kubectl describe deployment cluster-autoscaler -n kube-system