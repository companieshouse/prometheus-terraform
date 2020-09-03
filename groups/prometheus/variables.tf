# Region
variable "region" {
  type = string
}

# Tags
variable "tag_environment" {
  type    = string
}
variable "tag_service" {
  type    = string
  default = "prometheus"
}

# DNS
variable "zone_id" {
  type    = string
}
variable "zone_name" {
  type    = string
}

# EC2 Instances
variable "ami" {
  type = string
}
variable "instance_count" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}

# SSH
variable "ssh_keyname" {
  type    = string
}
variable "private_key_path" {
  type    = string
}
