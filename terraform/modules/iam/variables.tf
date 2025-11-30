variable "cluster_name" {
  description = "Name of the EKS cluster, used for IAM role naming."
  type        = string
}

variable "tags" {
  description = "Common tags to apply to IAM resources."
  type        = map(string)
  default     = {}
}
