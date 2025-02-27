# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"
#     redirect {
#       host        = "#{host}"
#       path        = "/"
#       port        = "443"
#       protocol    = "HTTPS"
#       query       = "#{query}"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 443
#   protocol          = "HTTPS"

#   ssl_policy      = "ELBSecurityPolicy-2016-08"
#   certificate_arn = data.aws_acm_certificate.domain_cert.arn

#   default_action {
#     type             = var.rules_type
#     target_group_arn = aws_lb_target_group.green.arn
#   }
# }

resource "aws_lb_listener" "dynamic_listener" {
  for_each = {
    http  = { port = 80,  protocol = "HTTP",  action_type = "redirect" }
    https = { port = 443, protocol = "HTTPS", action_type = "forward" }
  }
  load_balancer_arn = aws_lb.main.arn
  port              = each.value.port
  protocol          = each.value.protocol

  dynamic "default_action" {
    for_each = [each.value.action_type]
    content {
      type = each.value.action_type

      dynamic "redirect" {
        for_each = each.value.action_type == "redirect" ? [1] : []
        content {
          host        = "#{host}"
          path        = "/"
          port        = "443"
          protocol    = "HTTPS"
          query       = "#{query}"
          status_code = "HTTP_301"
        }
      }

      dynamic "forward" {
        for_each = each.value.action_type == "forward" ? [1] : []
        content {
          target_group {
            arn = aws_lb_target_group.groups["argocd-tg"].arn
          }
        }
      }
    }
  }

  ssl_policy      = each.value.protocol == "HTTPS" ? "ELBSecurityPolicy-2016-08" : null
  certificate_arn = each.value.protocol == "HTTPS" ? data.aws_acm_certificate.domain_cert.arn : null
}