variable "aws_region" {
  type    = string
}
variable "env" {
  type    = string
}

# variable "version" {
#   type    = string
# }
variable "cluster_name" {
  type    = string
}
variable "name" {
  type    = string
}




variable "common_tags" {
  type = map(any)
}
