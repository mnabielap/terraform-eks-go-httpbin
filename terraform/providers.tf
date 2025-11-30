# Global provider configuration for AWS, Kubernetes, and Helm.
# Kubernetes and Helm providers will usually be configured after
# the EKS cluster is created, using data sources and outputs.

variable "aws_region" {
  description = "AWS region where the EKS cluster and related resources will be created."
  type        = string
  default     = "ap-southeast-1"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "terraform"
    }
  }
}

# Kubernetes provider will be configured using the generated kubeconfig information.
# It is intentionally left commented here, and can be configured in a separate
# configuration file or workspace once the EKS cluster exists.
#
# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

# Similarly, Helm provider is usually configured to use the EKS cluster.
#
# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
#     token                  = data.aws_eks_cluster_auth.this.token
#   }
# }
