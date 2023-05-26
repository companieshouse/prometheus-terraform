locals {

  create_ssl_certificate  = var.ssl_certificate_name == "" ? true : false
  ssl_certificate_arn     = var.ssl_certificate_name == "" ? aws_acm_certificate_validation.certificate[0].certificate_arn : data.aws_acm_certificate.certificate[0].arn
}
