## Terraform block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.44.0"
    }
  }
}
# terraform {
#   backend "s3" {
#     bucket         = "dev-jurist-demo-project-tf-state"
#     key            = "alb/terraform.tfstate"
#     region         = "us-east-2"
#     dynamodb_table = "dev-jurist-demo-project-tf-state-lock"
#     encrypt        = true
#   }
# }

module "alb" {
  source     = "../../modules/alb"
  aws_region = "us-east-2"
  public_subnets = [
    "subnet-0a355d84a4e4bfe4c",
    "subnet-0ed04ad98d19f0578",
    "subnet-00d462ac31a53945b"
  ]
  private_subnets = [
    "subnet-0a355d84a4e4bfe4c",
    "subnet-0ed04ad98d19f0578",
    "subnet-00d462ac31a53945b"
  ]
  ingress_ports = [
    443,
    80,
    8080,
    9000,
    3000
  ]
  ip                   = ["0.0.0.0/0"]
  specific_ip          = ["10.10.0.0/16"]
  protocol_type        = "HTTPS"
  domain_name          = "thejurist.org.uk"
  is_it_internal       = false
  lb_type              = "application"
  delete_lb_protection = false
  protocol             = "HTTPS"
  rules_type           = "forward"

  rules = [
    {
      priority         = 101
      host_header      = "demo.thejurist.org.uk"
      target_group_arn = "demo-tg"
      protocol         = "http"
    },
    {
      priority         = 102
      host_header      = "grafana.thejurist.org.uk"
      target_group_arn = "grafana-tg"
      protocol         = "https"
    },
    {
      priority         = 103
      host_header      = "argocd.thejurist.org.uk"
      target_group_arn = "argocd-tg"
      protocol         = "https"
    },
    # {
    #   priority         = 104
    #   host_header      = "jenkins.thejurist.org.uk"
    #   target_group_arn = "jenkins-tg"
    #   protocol         = "https"
    # }
  ]
  target_groups = [
    {
      name                  = "demo-tg"
      port                  = 8080
      protocol              = "HTTP"
      target_type           = "ip"
      health_check_path     = "/"
      health_check_port     = 8080
      health_check_interval = 30
      health_check_timeout  = 5
      healthy_threshold     = 2
      unhealthy_threshold   = 2
    },
    {
      name                  = "grafana-tg"
      port                  = 3000
      protocol              = "HTTP"
      target_type           = "ip"
      health_check_path     = "/"
      health_check_port     = 3000
      health_check_interval = 30
      health_check_timeout  = 5
      healthy_threshold     = 2
      unhealthy_threshold   = 2
    },
    # {
    #   name                  = "jenkins-tg"
    #   port                  = 8080
    #   protocol              = "HTTP"
    #   target_type           = "instance"
    #   health_check_path     = "/login"
    #   health_check_port     = 8080
    #   health_check_interval = 30
    #   health_check_timeout  = 5
    #   healthy_threshold     = 2
    #   unhealthy_threshold   = 2
    # },
    {
      name                  = "argocd-tg"
      port                  = 80
      protocol              = "HTTP"
      target_type           = "ip"
      health_check_path     = "/healthz"
      health_check_port     = 80
      health_check_interval = 30
      health_check_timeout  = 5
      healthy_threshold     = 2
      unhealthy_threshold   = 2
    }
  ]
  common_tags = {
    "id"             = "2024"
    "owner"          = "jurist"
    "environment"    = "dev"
    "project"        = "blueops"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
    "company"        = "DEL"
    "backup"         = "true"
  }
}