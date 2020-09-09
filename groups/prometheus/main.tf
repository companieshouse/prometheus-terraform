provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

module "security-groups" {
  source           = "./module-security-groups"
  region           = var.region
  vpc_id           = local.vpc_id
  ssh_cidrs        = concat(local.internal_cidrs, local.vpn_cidrs)
  prometheus_cidrs = concat(local.mgmt_private_subnet_cidrs)
  tag_environment  = var.tag_environment
  tag_service      = var.tag_service
}

module "ec2-instances" {
  source                   = "./module-ec2-instances"
  instance_count           = var.instance_count
  instance_type            = var.instance_type
  ami_version_pattern      = var.ami_version_pattern
  application_subnets      = local.mgmt_private_subnet_ids
  vpc_security_group_ids   = module.security-groups.vpc_security_group_ids
  zone_name                = var.zone_name
  ssh_keyname              = var.ssh_keyname
  private_key_path         = var.private_key_path
  tag_environment          = var.tag_environment
  tag_service              = var.tag_service
  prometheus_web_fqdn  = var.prometheus_web_fqdn
  prometheus_metrics_port             = var.prometheus_metrics_port
}

module "route53-records" {
  source                   = "./module-route53-records"
  instance_count           = var.instance_count
  zone_id                  = var.zone_id
  zone_name                = var.zone_name
  ec2_instance_private_ips = module.ec2-instances.ec2_instance_private_ip[*]
  tag_environment          = var.tag_environment
  tag_service              = var.tag_service
}

# ------------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------------

locals {
  vpc_id                              = data.terraform_remote_state.management_vpc_eu_west_1.outputs.management_vpc_id
  mgmt_private_subnet_cidrs           = values(data.terraform_remote_state.management_vpc_eu_west_1.outputs.management_private_subnet_cidrs)
  mgmt_private_subnet_ids             = values(data.terraform_remote_state.management_vpc_eu_west_1.outputs.management_private_subnet_ids)
  vpn_cidrs                           = values(data.terraform_remote_state.management_vpc_eu_west_2.outputs.vpn_cidrs)
  internal_cidrs                      = concat(values(data.terraform_remote_state.management_vpc_eu_west_2.outputs.internal_cidrs), [data.terraform_remote_state.management_vpc_eu_west_2.outputs.dmz_subnet])
}

# ------------------------------------------------------------------------------
# Remote State
# ------------------------------------------------------------------------------

data "terraform_remote_state" "management_vpc_eu_west_1" {
  backend = "s3"
  config = {
    key    = "aws-common-infrastructure-terraform/common-eu-west-1/networking.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "management_vpc_eu_west_2" {
  backend = "s3"
  config = {
    key    = "aws-common-infrastructure-terraform/common-eu-west-2/networking.tfstate"
    region = "eu-west-2"
  }
}

