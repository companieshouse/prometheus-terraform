# Region
variable "region" {
  type = string
}

# Networking
variable "vpc_id" {
  type = string
}
variable "ssh_cidrs" {
  type = list(string)
}
variable "prometheus_cidrs" {
  type = list(string)
}

# Tags
variable "tag_environment" {
  type = string
}
variable "tag_service" {
  type = string
}
