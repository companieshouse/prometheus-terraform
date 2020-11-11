variable "ami_version_pattern" {
  type = string
  default = "*"
  description = "The AMI version pattern to be used"
}

variable "environment" {
  type = string
  description = "The environment name to be used when creating AWS resources"
}

variable "instance_count" {
  type = string
  description = "The number of EC2 instances to be provisoned"
}

variable "instance_type" {
  type = string
  default = "t3.small"
  description = "The type of EC2 instance to be provisoned"
}

variable "private_key_path" {
  type = string
  description = "The private key path to be used"
}

variable "prometheus_metrics_port" {
  type = string
  description = "The metrics port to be used"
}

variable "tag_name_regex" {
  type = string
  description = "The tag name regex uses to discover EC2 instances"
}

variable "region" {
  type = string
  description = "The AWS region to target"
}

variable "ssh_keyname" {
  type = string
  description = "The ssh key to be used"
}

variable "service" {
  type = string
  default = "prometheus"
  description = "The service name to be used when creating AWS resources"
}

variable "ssl_certificate_id" {
  type        = string
  description = "The ARN of the certificate for https access through the ALB."
}

variable "zone_id" {
  type  = string
  description = "The ID of the zone to be used"
}

variable "zone_name" {
  type = string
  description = "The zone name to be used"
}
