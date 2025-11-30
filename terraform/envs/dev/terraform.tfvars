# Variable values for the dev environment.

project_name = "eks-go-httpbin"
environment  = "dev"

aws_region = "ap-southeast-1"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
]

private_subnet_cidrs = [
  "10.0.101.0/24",
  "10.0.102.0/24",
]

azs = [
  "ap-southeast-1a",
  "ap-southeast-1b",
]

cluster_version = "1.30"

node_instance_type      = "t3.medium"
node_group_desired_size = 2
node_group_min_size     = 1
node_group_max_size     = 3
