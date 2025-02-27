# resource "aws_lb_target_group" "green" {
#   name        = "green-tg"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "instance"

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name = "green-tg"
#   }
# }

# resource "aws_lb_target_group" "yellow" {
#   name        = "yellow-tg"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "instance"

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name = "yellow-tg"
#   }
# }
# resource "aws_lb_target_group" "jenkins" {
#   name        = "jenkins-tg"
#   port        = 8080
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "instance"

#   health_check {
#     path                = "/login"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name        = "jenkins-tg"
#     Environment = "development"
#   }
# }

resource "aws_lb_target_group" "groups" {
  for_each = { for tg in var.target_groups : tg.name => tg }

  name        = each.value.name
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = data.aws_vpc.main.id
  target_type = each.value.target_type

  health_check {
    path                = each.value.health_check_path
    interval            = each.value.health_check_interval
    timeout             = each.value.health_check_timeout
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
  }

  tags = merge(var.common_tags, { Name = each.value.name })
}
