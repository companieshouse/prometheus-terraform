variable "ec2_instance_private_ips" {
  type = list(string)
  description = "The number of EC2 instances to be provisoned"
}

variable "tag_environment" {
  type = string
  description = "The environment name to be used when creating AWS resources"
}

variable "tag_service" {
  type = string
  escription = "The service name to be used when creating AWS resources"
}

variable "zone_id" {
  type = string
  description = "The zone ID to be used"
}

variable "zone_name" {
  type = string
  description = "The zone name to be used"
}

variable "instance_count" {
  type = number
  description = "The number of EC2 instances to be provisoned"
}
