# Instance
variable "instance_type" {
  type = string
}
variable "instance_count" {
  type = number
}

# Networking
variable "application_subnets" {
  type = list(string)
}
variable "vpc_security_group_ids" {
  type = string
}

# DNS
variable "zone_name" {
  type = string
}

# SSH
variable "ssh_keyname" {
  type = string
}
variable "private_key_path" {
  type = string
}

# Tags
variable "tag_environment" {
  type = string
}
variable "tag_service" {
  type = string
}
