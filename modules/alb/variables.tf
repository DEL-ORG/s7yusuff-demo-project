variable "aws_region" {
  type    = string
}
variable "ingress_ports" {
  type        = list(number)
}
variable "ip" {
  type    = list(string)
}
variable "specific_ip" {
  type    = list(string)
}
variable "protocol_type" {
  type = string
}
variable "common_tags" {
  type = map(any)
}

variable "rules_type" {
type = string
}
variable "domain_name" {
type = string
}
variable "protocol" {
type        = string
}
variable "lb_type" {
type = string
}
variable "is_it_internal" {
type = bool
}
variable "delete_lb_protection" {
type = bool
}
variable "public_subnets" {
type = list(string)
}

variable "private_subnets" {
type = list(string)
}
variable "target_groups" {
  type = list(object({
    name                = string
    port                = number
    protocol            = string
    target_type         = string
    health_check_path   = string
    health_check_port   = number
    health_check_interval = number
    health_check_timeout  = number
    healthy_threshold   = number
    unhealthy_threshold = number
  }))
}
variable "rules" {
type = list(object({
priority        = number
host_header     = string
target_group_arn = string
protocol = string
  }))
}