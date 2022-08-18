locals {

  validate_certificate = var.dns_zone_is_private ? tobool(false) : tobool(true)

}
