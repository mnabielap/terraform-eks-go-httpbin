# Example fixture file that could be used to provide shared values
# for multiple Terraform tests. This is mainly illustrative to
# demonstrate the use of fixtures in the project layout.

variables {
  project_name = "fixture-eks-go-httpbin"
  environment  = "fixture"
  aws_region   = "ap-southeast-1"

  vpc_cidr = "10.30.0.0/16"

  public_subnet_cidrs = [
    "10.30.1.0/24",
    "10.30.2.0/24",
  ]

  private_subnet_cidrs = [
    "10.30.101.0/24",
    "10.30.102.0/24",
  ]

  azs = [
    "ap-southeast-1a",
    "ap-southeast-1b",
  ]

  cluster_version          = "1.30"
  node_instance_type       = "t3.small"
  node_group_desired_size  = 1
  node_group_min_size      = 1
  node_group_max_size      = 2
}
