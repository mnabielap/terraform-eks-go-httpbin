variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where EKS will be provisioned."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EKS cluster and node groups."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster and node groups."
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS control plane."
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for the EKS managed node group."
  type        = string
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the managed node group."
  type        = number
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the managed node group."
  type        = number
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the managed node group."
  type        = number
}

variable "node_instance_types" {
  description = "List of instance types for the managed node group."
  type        = list(string)
}

variable "tags" {
  description = "Common tags to apply to EKS resources."
  type        = map(string)
  default     = {}
}
