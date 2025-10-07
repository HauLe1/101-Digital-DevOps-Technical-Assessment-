provider "aws" { region = var.region }
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.0.0"
  cluster_name = var.cluster_name
  cluster_version = var.k8s_version
  subnets = var.private_subnets
  vpc_id = var.vpc_id
  node_groups = {
    ng1 = {
      desired_capacity = var.node_desired_capacity
      max_capacity     = var.node_max_capacity
      min_capacity     = var.node_min_capacity
      instance_types   = var.instance_types
      key_name         = var.ssh_key_name
    }
  }
  tags = var.tags
}