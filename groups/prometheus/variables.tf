variable "ami_version_pattern" {
  type = string
  default = "*"
  description = "The AMI version pattern to be used"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use for deployment."
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

variable "github_exporter_docker_image" {
  type = string
  default = "infinityworks/github-exporter"
  description = "The name of the exporter container image."
}

variable "github_exporter_docker_tag" {
  type = string
  default = "release-1.0.2"
  description = "The version tag of the exporter container image."
}

variable "github_exporter_port" {
  type = string
  default = "9171"
  description = "The port exposed by the exporter container."
}

variable "github_exporter_token" {
  type = string
  description = "The Github API token of the user to gather metrics of."
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

variable "vault_username" {
  type        = string
  description = "The username used by the Vault provider."
}
variable "vault_password" {
  type        = string
  description = "The password used by the Vault provider."
}

variable "zone_id" {
  type  = string
  description = "The ID of the zone to be used"
}

variable "zone_name" {
  type = string
  description = "The zone name to be used"
}
