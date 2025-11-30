# Simple Terraform test that focuses on the network-related outputs.

run "network_outputs_are_not_empty" {
  command = "plan"

  module {
    source = "../.."
  }

  variables = {
    project_name = "test-network"
    environment  = "test"
    aws_region   = "ap-southeast-1"

    vpc_cidr = "10.20.0.0/16"

    public_subnet_cidrs = [
      "10.20.1.0/24",
      "10.20.2.0/24",
    ]

    private_subnet_cidrs = [
      "10.20.101.0/24",
      "10.20.102.0/24",
    ]

    azs = [
      "ap-southeast-1a",
      "ap-southeast-1b",
    ]

    cluster_version         = "1.30"
    node_instance_type      = "t3.small"
    node_group_desired_size = 1
    node_group_min_size     = 1
    node_group_max_size     = 2
  }

  assert {
    condition     = output.vpc_id.value != ""
    error_message = "VPC ID output must not be empty."
  }

  assert {
    condition     = length(output.public_subnet_ids.value) > 0
    error_message = "There must be at least one public subnet ID."
  }

  assert {
    condition     = length(output.private_subnet_ids.value) > 0
    error_message = "There must be at least one private subnet ID."
  }
}
