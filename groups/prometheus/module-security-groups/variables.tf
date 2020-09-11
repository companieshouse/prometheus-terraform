variable "region" {
  type = string
  description = "The AWS region to target"
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC to be used"
}

variable "ssh_cidrs" {
  type = list(string)
  description = "The SSH of the CIDR to be used"
}

variable "prometheus_cidrs" {
  type = list(string)
  description = "The Prometheus CIDR to be used"

}

variable "environment" {
  type = string
  description = "The environment name to be used when creating AWS resources"
}

variable "service" {
  type = string
  description = "The service name to be used when creating AWS resources"
}
