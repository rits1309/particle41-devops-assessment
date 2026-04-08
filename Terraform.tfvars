aws_region           = "ap-south-1"
project_name         = "simpletimeservice"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
eks_cluster_version  = "1.29"
node_instance_type   = "m6a.large"
node_count           = 2