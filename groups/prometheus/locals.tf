locals {

  acm_pca_certificate_arn   = var.dns_zone_is_private ? data.vault_generic_secret.secrets.data["acm_pca_certificate_arn"] : ""
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

}
