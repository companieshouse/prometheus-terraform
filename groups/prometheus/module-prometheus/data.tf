data "aws_acm_certificate" "certificate" {
  count = local.create_ssl_certificate ? 0 : 1

  domain      = var.ssl_certificate_name
  statuses    = ["ISSUED"]
  most_recent = true
}
