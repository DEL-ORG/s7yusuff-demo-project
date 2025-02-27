variable "aws_region" {
  type    = string
}
variable "ttl" {
  type = number
}
variable "record_type" {
  type = string
}
variable "subdomain" {
  type = string
}
variable "domain" {
  type = string
}
variable "zone_id" {
  type = string
}

variable "common_tags" {
  type = map(any)
}