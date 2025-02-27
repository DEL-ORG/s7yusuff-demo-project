resource "aws_lb" "main" {
  name               = format("%s-%s-%s-alb", var.common_tags["environment"], var.common_tags["owner"], var.common_tags["project"])
  internal           = var.is_it_internal
  load_balancer_type = var.lb_type
  security_groups    = [data.aws_security_group.sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = var.delete_lb_protection

  tags = merge(var.common_tags, {
    Name = format("%s-%s-%s-alb", var.common_tags["environment"], var.common_tags["owner"], var.common_tags["project"])
  })
}

