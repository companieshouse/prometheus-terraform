data "vault_generic_secret" "secrets" {
  path = "applications/${var.aws_profile}/${var.environment}/${var.service}"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = [var.subnet_pattern]
  }
}

data "aws_subnet" "subnet_data" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

data "aws_route53_zone" "dns_zone" {
  name         = var.dns_zone_name
  private_zone = var.dns_zone_is_private
}
