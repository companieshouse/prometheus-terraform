provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

module "prometheus" {
  source                       = "./module-prometheus"

  ami_owner                    = local.ami_owner
  ami_version_pattern          = var.ami_version_pattern
  application_subnets          = local.mgmt_private_subnet_ids
  environment                  = var.environment
  instance_count               = var.instance_count
  instance_type                = var.instance_type
  prometheus_cidrs             = concat(local.mgmt_private_subnet_cidrs)
  github_exporter_port         = var.github_exporter_port
  github_exporter_token        = local.github_exporter_token
  github_exporter_docker_image = var.github_exporter_docker_image
  github_exporter_docker_tag   = var.github_exporter_docker_tag
  prometheus_metrics_port      = var.prometheus_metrics_port
  tag_name_regex               = var.tag_name_regex
  region                       = var.region
  service                      = var.service
  ssh_cidrs                    = local.internal_cidrs
  ssh_keyname                  = var.ssh_keyname
  vpc_id                       = data.aws_vpc.vpc.id
  web_cidrs                    = local.internal_cidrs
  dns_zone_id                  = data.aws_route53_zone.dns_zone.zone_id
  dns_zone_name                = local.dns_zone_name
  ssl_certificate_name         = var.ssl_certificate_name
}
