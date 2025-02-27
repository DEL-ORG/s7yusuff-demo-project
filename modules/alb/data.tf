# data "aws_vpc" "main" {
#   filter {
#     name   = "is-default"
#     values = ["false"]
#   }
#   filter {
#     name   = "tag:environment"
#     values = ["dev"]
#   }
# }

# data "aws_subnets" "public_subnets" {
#   filter {
#     name   = "tag:SubnetType"
#     values = ["Public"] 
#   }
# }
# data "aws_subnet" "public" {
#   filter {
#     name   = "tag:Name"
#     values = ["dev-blueops-jurist-public-subnet-1-us-east-2a"]
#   }
# }
data "aws_vpc" "main" {
  default = true
}
data "aws_acm_certificate" "domain_cert" {
    domain = var.domain_name
    most_recent = true
    statuses   = ["ISSUED"]
}
data "aws_security_group" "sg" {
 name = "jurist"
}

# data "aws_security_group" "alb_sg" {
#   filter {
#     name   = "tag:Name"
#     values = ["alb-sg"]
#   }

#   filter {
#     name   = "tag:Environment"
#     values = ["development"]
#   }
# }

# # Data source to get ALB Target Group by name
# data "aws_lb_target_group" "jenkins_target_group" {
#   name = "jenkins-tg"
# }

# # Data source to get ALB by name
# data "aws_lb" "alb" {
#   name = "alb" # Replace with your ALB name
# }