# resource "aws_lb_listener_rule" "green" {
#   listener_arn = aws_lb_listener.https_listener.arn
#   priority     = 101

#   condition {
#     host_header {
#       values = ["green.thejurist.org.uk"]
#     }
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.green.arn
#   }
# }

# resource "aws_lb_listener_rule" "yellow" {
#   listener_arn = aws_lb_listener.https_listener.arn
#   priority     = 102

#   condition {
#     host_header {
#       values = ["yellow.thejurist.org.uk"]
#     }
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.yellow.arn
#   }
# }

# resource "aws_lb_listener_rule" "jenkins" {
#   listener_arn = aws_lb_listener.https_listener.arn
#   priority     = 103

#   condition {
#     host_header {
#       values = ["jenkins.thejurist.org.uk"]
#     }
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.jenkins.arn
#   }
# }

resource "aws_lb_listener_rule" "dynamic" {
  for_each = { for rule in var.rules : rule.priority => rule }

  listener_arn = aws_lb_listener.dynamic_listener[each.value.protocol].arn
  # listener_arn = aws_lb_listener.dynamic_listener[lower(each.value.protocol)].arn
  priority     = each.value.priority

  condition {
    host_header {
      values = [each.value.host_header]
    }
  }

  action {
    type             = var.rules_type
    target_group_arn = aws_lb_target_group.groups[each.value.target_group_arn].arn
  }
}
