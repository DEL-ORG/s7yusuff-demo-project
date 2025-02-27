terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.44.0"
    }
  }
}

# locals {
# aws_region    = "us-east-2"
# env = "dev"
# ns = "argo-cd"
# cluster_name = "dev-jurist-blueops-control-plane"
# version = "2.0.1" 
# name = "demo-project"
# common_tags = {
#   "id"             = "2024"
#   "owner"          = "jurist"
#   "environment"    = "dev"
#   "project"        = "blueops"
#   "create_by"      = "Terraform"
#   "cloud_provider" = "aws"
#   "company"        = "DEL"
# }
# }

module "argocd" {
  source       = "../../modules/argocd"
  aws_region   = "us-east-2"
  env          = "dev"
  cluster_name = "dev-jurist-blueops-control-plane"
  # version = "2.0.1" 
  ecr-lb      = "602401143452.dkr.ecr.us-east-2.amazonaws.com/amazon/aws-load-balancer-controller"
  domain_name = "thejurist.org.uk"
  name        = "demo-project"
  common_tags = {
    "id"             = "2024"
    "owner"          = "jurist"
    "environment"    = "dev"
    "project"        = "blueops"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
    "company"        = "DEL"
  }
}

