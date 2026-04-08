
variable "aws_region" {
  description = "AWS region where all resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix used for all resources"
  type        = string
  default     = "simpletimeservice"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the 2 public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the 2 private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "m6a.large"
}

variable "node_count" {
  description = "Number of worker nodes in the EKS node group"
  type        = number
  default     = 2
}
