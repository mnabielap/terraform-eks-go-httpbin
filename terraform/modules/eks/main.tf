# EKS module: creates the EKS cluster and a managed node group.

# Security group for the EKS cluster endpoint and worker nodes.
resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS control plane and worker nodes."
  vpc_id      = var.vpc_id

  # Example: allow inbound HTTPS for cluster API access from anywhere.
  # In a real setup, this should be restricted to trusted IPs or VPN.
  ingress {
    description = "Allow HTTPS from anywhere to EKS API endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic within the security group (node <-> node, node <-> control plane).
  ingress {
    description = "Allow all traffic within the security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-cluster-sg"
    }
  )
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  kubernetes_network_config {
    ip_family = "ipv4"
  }

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
    }
  )

  depends_on = [
    aws_security_group.cluster
  ]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = var.node_role_arn

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  subnet_ids = var.private_subnet_ids != [] ? var.private_subnet_ids : var.public_subnet_ids

  instance_types = var.node_instance_types

  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-ng"
    }
  )

  depends_on = [
    aws_eks_cluster.this
  ]
}

data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}
