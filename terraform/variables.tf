# Root-level input variables for the EKS infrastructure.

variable "project_name" {
  description = "Base project name used for tagging and resource naming."
  type        = string
  default     = "eks-go-httpbin"
}

variable "environment" {
  description = "Deployment environment (for example: dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
  ]
}

variable "azs" {
  description = "List of availability zones to be used for the subnets."
  type        = list(string)
  default = [
    "ap-southeast-1a",
    "ap-southeast-1b",
  ]
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.30"
}

variable "node_instance_type" {
  description = "Instance type for the EKS managed node group."
  type        = string
  default     = "t3.medium"
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes in the node group."
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes in the node group."
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes in the node group."
  type        = number
  default     = 4
}
