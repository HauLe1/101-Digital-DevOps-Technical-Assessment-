terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
  backend "s3" {
    bucket = var.terraform_state_bucket
    key    = "${var.environment}/terraform.tfstate"
    region = var.region
    dynamodb_table = var.terraform_lock_table
  }
}
provider "aws" {
  region = var.region
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
module "vpc" {
  source = "./modules/vpc"
  # pass variables...
}
module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  cluster_name    = var.cluster_name
}
module "vpc" {
  source = "./modules/vpc"
  # pass variables...
}
module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  cluster_name    = var.cluster_name
}