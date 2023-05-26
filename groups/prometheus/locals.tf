locals {

  internal_cidrs            = values(data.vault_generic_secret.internal_cidrs.data)
  vpc_id                    = data.aws_vpc.vpc.id

  subnets_map               = {
    for s in data.aws_subnet.subnet_data: "${s.tags.Name}" => {
        subnet_id   = s.id,
        subnet_cidr = s.cidr_block
    }
  }

  mgmt_private_subnet_ids   = [ for name, data in local.subnets_map: data.subnet_id ]
  mgmt_private_subnet_cidrs = [ for name, data in local.subnets_map: data.subnet_cidr ]

  secrets                   = data.vault_generic_secret.secrets.data
  dns_zone_name             = local.secrets.dns_zone_name
  github_exporter_token     = local.secrets.github_exporter_token
  placement_subnet_pattern  = local.secrets.placement_subnet_pattern
  placement_vpc_pattern     = local.secrets.placement_vpc_pattern

}
