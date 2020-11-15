provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

module "prometheus" {
  ami_version_pattern          = var.ami_version_pattern
  application_subnets          = local.mgmt_private_subnet_ids
  environment                  = var.environment
  instance_count               = var.instance_count
  instance_type                = var.instance_type
  private_key_path             = var.private_key_path
  prometheus_cidrs             = concat(local.mgmt_private_subnet_cidrs)
  github_exporter_port         = var.github_exporter_port
  github_exporter_token        = data.vault_generic_secret.secrets.data["github_exporter_token"]
  github_exporter_docker_image = var.github_exporter_docker_image
  github_exporter_docker_tag   = var.github_exporter_docker_tag
  prometheus_metrics_port      = var.prometheus_metrics_port
  tag_name_regex               = var.tag_name_regex
  region                       = var.region
  service                      = var.service
  source                       = "./module-prometheus"
  ssh_cidrs                    = concat(local.internal_cidrs, local.vpn_cidrs)
  ssh_keyname                  = var.ssh_keyname
  vpc_id                       = local.vpc_id
  zone_id                      = var.zone_id
  zone_name                    = var.zone_name
}

# ------------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------------

locals {
  vpc_id                    = data.terraform_remote_state.management_vpc.outputs.management_vpc_id
  mgmt_private_subnet_cidrs = values(data.terraform_remote_state.management_vpc.outputs.management_private_subnet_cidrs)
  mgmt_private_subnet_ids   = values(data.terraform_remote_state.management_vpc.outputs.management_private_subnet_ids)
  vpn_cidrs                 = values(data.terraform_remote_state.management_vpc.outputs.vpn_cidrs)
  internal_cidrs            = concat(values(data.terraform_remote_state.management_vpc.outputs.internal_cidrs), [data.terraform_remote_state.management_vpc.outputs.dmz_subnet])
}

# ------------------------------------------------------------------------------
# Remote State
# ------------------------------------------------------------------------------

data "terraform_remote_state" "management_vpc" {
  backend = "s3"
  config = {
    bucket = "development-${var.region}.terraform-state.ch.gov.uk"
    key    = "aws-common-infrastructure-terraform/common-${var.region}/networking.tfstate"
    region = var.region
  }
}
