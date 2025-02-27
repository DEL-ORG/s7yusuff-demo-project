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
# aws_region = "us-east-2"
# subdomain = "argocd"
# record_type = "CNAME"
# domain = "thejurist.org.uk"
# ttl = 60
# zone_id = "Z10133933QJB0LVB8X0ER"
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
  source      = "../../modules/records"
  aws_region  = "us-east-2"
  subdomain   = "argocd"
  record_type = "CNAME"
  domain      = "thejurist.org.uk"
  ttl         = 60
  zone_id     = "Z10133933QJB0LVB8X0ER"
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

