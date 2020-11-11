variable "ami_version_pattern" {
  type = string
  description = "The AMI version pattern to be used"
}

variable "application_subnets" {
  type = list(string)
  description = "The application subnets to be used"
}

variable "environment" {
  type = string
  description = "The environment name to be used when creating AWS resources"
}

variable "instance_count" {
  type = number
  description = "The number of EC2 instances to be provisoned"
}

variable "instance_type" {
  type = string
  description = "The type of EC2 instance to be provisoned"
}

variable "prometheus_metrics_port" {
  type = string
  description = "The metrics port to be used"
}

variable "tag_name_regex" {
  type = string
  description = "The tag name regex uses to discover EC2 instances"
}

variable "private_key_path" {
  type = string
  description = "The private key path to be used"
}

variable "prometheus_cidrs" {
  type = list(string)
  description = "The Prometheus CIDR to be used"
}

variable "region" {
  type = string
  description = "The AWS region to target"
}

variable "service" {
  type = string
  description = "The service name to be used when creating AWS resources"
}

variable "ssh_cidrs" {
  type = list(string)
  description = "The SSH of the CIDR to be used"
}

variable "ssh_keyname" {
  type = string
  description = "The ssh key to be used"
}

variable "ssl_certificate_id" {
  type        = string
  description = "The ARN of the certificate for https access through the ALB."
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC to be used"
}

variable "web_cidrs" {
  type = list(string)
  description = "The CIDRs to grant web access to"
}

variable "zone_id" {
  type = string
  description = "The zone ID to be used"
}

variable "zone_name" {
  type = string
  description = "The zone name to be used"
}
