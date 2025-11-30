# Variable values for the prod environment.

project_name = "eks-go-httpbin"
environment  = "prod"

aws_region = "ap-southeast-1"

vpc_cidr = "10.1.0.0/16"

public_subnet_cidrs = [
  "10.1.1.0/24",
  "10.1.2.0/24",
]

private_subnet_cidrs = [
  "10.1.101.0/24",
  "10.1.102.0/24",
]

azs = [
  "ap-southeast-1a",
  "ap-southeast-1b",
]

cluster_version = "1.30"

# Slightly larger node group for prod.
node_instance_type      = "t3.large"
node_group_desired_size = 3
node_group_min_size     = 2
node_group_max_size     = 5
