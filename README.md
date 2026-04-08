# Terraform — AWS VPC + EKS Cluster

This Terraform configuration creates the following AWS infrastructure:

- A **VPC** with 2 public and 2 private subnets across 2 availability zones
- A **NAT Gateway** so private subnet nodes can reach the internet
- An **EKS cluster** (Kubernetes) deployed into the VPC
- An **EKS Node Group** with 2 x `m6a.large` nodes on private subnets only

---

## Prerequisites

Make sure the following tools are installed:

| Tool | Purpose | Install Link |
|------|---------|--------------|
| Terraform | Infrastructure as Code | https://developer.hashicorp.com/terraform/install |
| AWS CLI | Authenticate to AWS | https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html |
| kubectl | Interact with EKS cluster | https://kubernetes.io/docs/tasks/tools/ |

---

## AWS Authentication

**Never commit AWS credentials to the repository.**

Configure your AWS credentials using one of these methods:

### Option 1 — AWS CLI (recommended)

```bash
aws configure
```

Enter your:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `ap-south-1`
- Output format: `json`

### Option 2 — Environment Variables

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="ap-south-1"
```

### Option 3 — IAM Role (for CI/CD or EC2)

Attach an IAM role with the required permissions to your instance or pipeline.

---

## Required IAM Permissions

The AWS user or role running Terraform needs the following permissions:

- `AmazonVPCFullAccess`
- `AmazonEKSClusterPolicy`
- `AmazonEKSWorkerNodePolicy`
- `IAMFullAccess` (to create roles and attach policies)

---

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/rits1309/particle41-devops-assessment.git
cd particle41-devops-assessment/terraform
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the plan

```bash
terraform plan
```

### 4. Apply the infrastructure

```bash
terraform apply
```

Type `yes` when prompted. This will take approximately **10-15 minutes** to complete.

### 5. Configure kubectl

After apply completes, run the output command to configure kubectl:

```bash
aws eks update-kubeconfig --region ap-south-1 --name simpletimeservice-eks-cluster
```

### 6. Verify the cluster

```bash
kubectl get nodes
```

You should see 2 nodes in `Ready` state.

---

## Deploy SimpleTimeService to the cluster

Once the cluster is up, deploy the application:

```bash
cd ../app
kubectl apply -f microservice.yml
kubectl get pods
kubectl get svc
```

---

## Variables

All variables can be overridden in `terraform.tfvars`:

| Variable | Default | Description |
|----------|---------|-------------|
| `aws_region` | `ap-south-1` | AWS region |
| `project_name` | `simpletimeservice` | Prefix for all resource names |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `public_subnet_cidrs` | `["10.0.1.0/24", "10.0.2.0/24"]` | Public subnet CIDRs |
| `private_subnet_cidrs` | `["10.0.3.0/24", "10.0.4.0/24"]` | Private subnet CIDRs |
| `eks_cluster_version` | `1.29` | Kubernetes version |
| `node_instance_type` | `m6a.large` | EC2 instance type for nodes |
| `node_count` | `2` | Number of worker nodes |

---

## Outputs

After `terraform apply`, the following outputs are shown:

| Output | Description |
|--------|-------------|
| `vpc_id` | ID of the created VPC |
| `public_subnet_ids` | IDs of the 2 public subnets |
| `private_subnet_ids` | IDs of the 2 private subnets |
| `eks_cluster_name` | Name of the EKS cluster |
| `eks_cluster_endpoint` | API server endpoint |
| `kubeconfig_command` | Command to configure kubectl |

---

## Teardown

To destroy all created resources:

```bash
terraform destroy
```

Type `yes` when prompted.

> **Note:** Destroying the infrastructure will delete all resources including the EKS cluster and VPC. Make sure to remove any manually created resources (like load balancers) before running destroy, or it may fail.
