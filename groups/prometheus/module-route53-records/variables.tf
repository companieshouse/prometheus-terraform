# DNS
variable "zone_id" {
  type = string
}
variable "zone_name" {
  type = string
}

# Instance
variable "ec2_instance_private_ips" {
  type = list(string)
}
variable "instance_count" {
  type = number
}

# Tags
variable "tag_environment" {
  type = string
}
variable "tag_service" {
  type = string
}
