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
variable "instance_count" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}
variable "ami_version_pattern" {
  type = string
  default = "*"
}

# SSH
variable "ssh_keyname" {
  type    = string
}
variable "private_key_path" {
  type    = string
}

# Concourse Prometheus
variable "web_fqdn" {
  type = string
}

variable "metrics_port" {
  type = string
}
