terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.44.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  aws_region = "us-east-2"
  source_instance_id = "dev-jurist-demo-project-main-server"
  common_tags = {
    "id"             = "2024"
    "name"           = "demo project-ami"
    "owner"          = "jurist"
    "environment"    = "dev"
    "project"        = "demo-project"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
    "company"        = "DEL"
  }
}

module "AMI" {
  source      = "../../modules/ami"
  aws_region  = local.aws_region
  common_tags = local.common_tags
  source_instance_id = local.source_instance_id
 
}

