locals {
  parameter_store_path   = "/${var.service}/${var.environment}/github_exporter_token"
  create_ssl_certificate = var.ssl_certificate_name == "" ? true : false
  ssl_certificate_arn    = var.ssl_certificate_name == "" ? aws_acm_certificate_validation.certificate[0].certificate_arn : data.aws_acm_certificate.certificate[0].arn

  default_tags = {
    Terraform   = "true"
    Application = upper(var.service)
    Environment = var.environment
  }
}
