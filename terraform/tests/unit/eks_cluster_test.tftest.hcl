# Simple Terraform test for the EKS root module.
# The goal is to verify that important outputs are set.

run "eks_cluster_outputs_are_not_empty" {
  command = "plan"

  # Use the root module as the configuration under test.
  module {
    source = "../.."
  }

  variables = {
    project_name = "test-eks-go-httpbin"
    environment  = "test"
    aws_region   = "ap-southeast-1"

    vpc_cidr = "10.10.0.0/16"

    public_subnet_cidrs = [
      "10.10.1.0/24",
      "10.10.2.0/24",
    ]

    private_subnet_cidrs = [
      "10.10.101.0/24",
      "10.10.102.0/24",
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
    condition     = output.cluster_name.value != ""
    error_message = "EKS cluster name output must not be empty."
  }

  assert {
    condition     = output.cluster_endpoint.value != ""
    error_message = "EKS cluster endpoint output must not be empty."
  }

  assert {
    condition     = output.cluster_ca_certificate.value != ""
    error_message = "Cluster CA certificate output must not be empty."
  }
}
