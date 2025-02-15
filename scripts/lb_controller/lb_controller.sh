#!/bin/bash

# ===============================
# ⚡ Configuration Variables
# ===============================
PROJECT_NAME="project"                                                  # Replace with your Actual Project Name
AWS_REGION="us-east-1"                                                  # Replace with your AWS Region
EKS_CLUSTER_NAME="${PROJECT_NAME}_cluster"                              # Replace with your EKS cluster name
AWS_ACCOUNT_ID="123456789012"                                           # Replace with your AWS Account ID
LB_CONTROLLER_VERSION="v2.11.0"                                         # Load Balancer Controller version
CERT_MANAGER_VERSION="v1.13.5"                                          # Cert Manager version
CERT_MANAGER_CAINJECTOR="${PROJECT_NAME}_cert_manager_cainjector"       # Replace with actual ECR Repository for cert-manager-cainjector
CERT_MANAGER_CONTROLLER="${PROJECT_NAME}_cert_manager_controller"       # Replace with actual ECR Repository for cert-manager-controller
CERT_MANAGER_WEBHOOK="${PROJECT_NAME}_cert_manager_webhook"             # Replace with actual ECR Repository for cert-manager-webhook
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"    # Password for ECR Registry

# ===============================
# Step 1️⃣: Create IAM Policy for AWS Load Balancer Controller
# ===============================
echo "🔹 Downloading IAM policy for Load Balancer Controller..."
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${LB_CONTROLLER_VERSION}/docs/install/iam_policy.json

echo "🔹 Creating IAM policy..."
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json || echo "✅ IAM Policy already exists, skipping..."

# ===============================
# Step 2️⃣: Retrieve OIDC Provider and Create IAM Role
# ===============================
echo "🔹 Retrieving OIDC provider for EKS cluster..."
OIDC_ID=$(aws eks describe-cluster --name $EKS_CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f5)

echo "🔹 Checking if OIDC provider exists..."
EXISTING_OIDC=$(aws iam list-open-id-connect-providers | grep $OIDC_ID | cut -d "/" -f4 || true)

if [ -z "$EXISTING_OIDC" ]; then
  echo "✅ Creating OIDC Provider..."
  aws iam create-open-id-connect-provider \
    --url https://oidc.eks.$AWS_REGION.amazonaws.com/id/$OIDC_ID \
    --client-id-list "sts.amazonaws.com" \
    --thumbprint-list "9e99a48a9960b14926bb7f3b02e22da2b0ec0445"
else
  echo "✅ OIDC Provider already exists, skipping creation."
fi

# Create IAM Role Trust Policy dynamically
echo "🔹 Creating IAM Role for Load Balancer Controller..."
cat > temp-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/oidc.eks.${AWS_REGION}.amazonaws.com/id/${OIDC_ID}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.${AWS_REGION}.amazonaws.com/id/${OIDC_ID}:aud": "sts.amazonaws.com",
                    "oidc.eks.${AWS_REGION}.amazonaws.com/id/${OIDC_ID}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
EOF

aws iam create-role \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --assume-role-policy-document file://temp-trust-policy.json || echo "✅ IAM Role might already exist or there was an error, skipping..."

# Clean up the temporary policy file
rm temp-trust-policy.json

# Attach IAM Policy to the Role
echo "🔹 Attaching IAM Policy to Role..."
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
  --role-name AmazonEKSLoadBalancerControllerRole

echo "✅ Attached IAM Policy to Role"

# ===============================
# Step 3️⃣: Create Kubernetes Service Account
# ===============================
echo "🔹 Creating Kubernetes Service Account..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${AWS_ACCOUNT_ID}:role/AmazonEKSLoadBalancerControllerRole
EOF

# ===============================
# Step 4️⃣: Install cert-manager using private ECR registry
# ===============================

# Download the manifest
curl -Lo cert-manager.yaml https://github.com/jetstack/cert-manager/releases/download/v1.13.5/cert-manager.yaml

# Pulling required Docker images ...
# Using amd64 images to ensure compatibility with x86_64 architecture nodes in the cluster.

# Pulling cert-manager-cainjector:v1.13.5
docker pull --platform=linux/amd64 quay.io/jetstack/cert-manager-cainjector:v1.13.5

# Pulling cert-manager-controller:v1.13.5
docker pull --platform=linux/amd64 quay.io/jetstack/cert-manager-controller:v1.13.5

# Pulling cert-manager-webhook:v1.13.5
docker pull --platform=linux/amd64 quay.io/jetstack/cert-manager-webhook:v1.13.5

# Authenticate Docker to AWS ECR
echo "🔹 Authenticating Docker with ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}

# Docker tag to AWS ECR
docker tag quay.io/jetstack/cert-manager-cainjector:v1.13.5 ${ECR_REGISTRY}/${CERT_MANAGER_CAINJECTOR}:latest
docker tag quay.io/jetstack/cert-manager-controller:v1.13.5 ${ECR_REGISTRY}/${CERT_MANAGER_CONTROLLER}:latest
docker tag quay.io/jetstack/cert-manager-webhook:v1.13.5 ${ECR_REGISTRY}/${CERT_MANAGER_WEBHOOK}:latest

# Docker push to AWS ECR Repositories
docker push ${ECR_REGISTRY}/${CERT_MANAGER_CAINJECTOR}:latest
docker push ${ECR_REGISTRY}/${CERT_MANAGER_CONTROLLER}:latest
docker push ${ECR_REGISTRY}/${CERT_MANAGER_WEBHOOK}:latest

# Push images to ECR Repositories
echo "✅ All images have been successfully pushed to ECR!"

# ===============================
# Step 4️⃣: Update manifest to point to your ECR images
# ===============================
echo "🔹 Updating cert-manager manifest to use private registry..."

sed -i.bak \
-e "s|quay.io/jetstack/cert-manager-controller:v1.13.5|${ECR_REGISTRY}/${CERT_MANAGER_CONTROLLER}:latest|g" \
-e "s|quay.io/jetstack/cert-manager-webhook:v1.13.5|${ECR_REGISTRY}/${CERT_MANAGER_WEBHOOK}:latest|g" \
-e "s|quay.io/jetstack/cert-manager-cainjector:v1.13.5|${ECR_REGISTRY}/${CERT_MANAGER_CAINJECTOR}:latest|g" \
cert-manager.yaml

echo "🔹 Updating imagePullPolicy from 'IfNotPresent' to 'Always' ..."
sed -i.bak \
-e "s|IfNotPresent|Always|g" \
-e "s|IfNotPresent|Always|g" \
-e "s|IfNotPresent|Always|g" \
cert-manager.yaml

echo "✅ imagePullPolicy updated successfully!"
echo "✅ cert-manager manifest updated successfully!"


# 5️⃣ Apply the updated manifest to the cluster
echo "🔹 Deploying cert-manager to EKS cluster..."
kubectl apply --validate=false -f ./cert-manager.yaml

echo "✅ cert-manager installation complete!"

# 6️⃣ Check the deployment status
kubectl get pods -n cert-manager

# ===============================
# 🔁 Download Controller Manifest
# ===============================
echo "🔹 Downloading AWS Load Balancer Controller manifest..."
curl -Lo v2_11_0_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/${LB_CONTROLLER_VERSION}/v2_11_0_full.yaml

# ===============================
# 🛏️ Remove Default ServiceAccount Section
# ===============================
echo "🔹 Removing ServiceAccount section from manifest..."
sed -i.bak -e '690,698d' ./v2_11_0_full.yaml

# ===============================
# 🌐 Update Cluster Name in Manifest
# ===============================
echo "🔹 Updating cluster name in manifest..."
sed -i.bak -e "s|your-cluster-name|${EKS_CLUSTER_NAME}|" ./v2_11_0_full.yaml

# ===============================
# 🛦️ Push Controller Image to Private ECR (if necessary)
# ===============================
# If your nodes don’t have access to the Amazon EKS Amazon ECR image repositories, 
# then you need to pull the following image and push it to a repository that your 
# nodes have access to.
# Make sure to update the Manifest with your Private Registry URL

# echo "🔹 Pulling AWS Load Balancer Controller image from public ECR..."
# docker pull public.ecr.aws/eks/aws-load-balancer-controller:v${LB_CONTROLLER_VERSION}

# echo "🔹 Tagging and pushing image to private ECR..."
# docker tag public.ecr.aws/eks/aws-load-balancer-controller:v${LB_CONTROLLER_VERSION} ${PRIVATE_REGISTRY}/eks/aws-load-balancer-controller:v${LB_CONTROLLER_VERSION}

# aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${PRIVATE_REGISTRY}
# docker push ${PRIVATE_REGISTRY}/eks/aws-load-balancer-controller:v${LB_CONTROLLER_VERSION}

# ===============================
# 🔹 Update Manifest with Private Registry Image
# ===============================
# echo "🔹 Updating manifest to use private registry image..."
# sed -i.bak -e "s|public.ecr.aws/eks/aws-load-balancer-controller|${PRIVATE_REGISTRY}/eks/aws-load-balancer-controller|g" ./v2_11_0_full.yaml

# ===============================
# 🔹 (Optional) Add Args for Fargate or Restricted IMDS
# ===============================
# Uncomment and update if needed
# sed -i.bak '/- --cluster-name/a \ \ \ \ \ \ \ \ - --aws-vpc-id=vpc-xxxxxxxx\n \ \ \ \ \ \ \ \ - --aws-region=${AWS_REGION}' ./v2_11_0_full.yaml

# ===============================
# 📁 Apply Controller Manifest
# ===============================
echo "🔹 Applying AWS Load Balancer Controller manifest..."
kubectl apply -f v2_11_0_full.yaml

# ===============================
# 🔁 Download IngressClass and IngressClassParams Manifest
# ===============================
echo "🔹 Downloading IngressClass and IngressClassParams manifest..."
curl -Lo v2_11_0_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/${LB_CONTROLLER_VERSION}/v2_11_0_ingclass.yaml

# ===============================
# 📁 Apply IngressClass Manifest
# ===============================
echo "🔹 Applying IngressClass manifest..."
kubectl apply -f v2_11_0_ingclass.yaml

# ===============================
# 📊 Verify Deployment
# ===============================
echo "🔹 Verifying AWS Load Balancer Controller deployment..."
kubectl get deployment -n kube-system aws-load-balancer-controller

echo "🌟 AWS Load Balancer Controller setup is complete!"

# Clean up the temporary policy file
rm v2_11_0_full.yaml.bak v2_11_0_ingclass.yaml
