# Root-level outputs, mostly re-exporting module outputs.

output "region" {
  description = "AWS region where the infrastructure is deployed."
  value       = var.aws_region
}

output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.network.private_subnet_ids
}

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate authority data for the EKS cluster."
  value       = module.eks.cluster_ca_certificate
  sensitive   = true
}

output "cluster_oidc_issuer" {
  description = "OIDC issuer URL for the EKS cluster."
  value       = module.eks.cluster_oidc_issuer
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster."
  value       = module.eks.cluster_security_group_id
}

output "node_group_name" {
  description = "Name of the managed node group."
  value       = module.eks.node_group_name
}

output "kubeconfig" {
  description = "Kubeconfig content that can be written to a file and used with kubectl."
  value       = module.eks.kubeconfig
  sensitive   = true
}
