locals {
  parameter_store_path = "/${var.service}/${var.environment}/github_exporter_token"

  security_ssm_kms_key_id  = data.vault_generic_secret.security_kms_keys.data["session-manager-kms-key-arn"]  
  security_ssm_bucket_name = data.vault_generic_secret.security_s3_buckets.data["session-manager-bucket-name"]

  create_ssl_certificate = var.ssl_certificate_name == "" ? true : false
  ssl_certificate_arn    = var.ssl_certificate_name == "" ? aws_acm_certificate_validation.certificate[0].certificate_arn : data.aws_acm_certificate.certificate[0].arn
  
  elb_access_logs_prefix      = "elb-access-logs"
  elb_access_logs_bucket_name = data.vault_generic_secret.security_s3_buckets.data["elb-access-logs-bucket-name"]

  default_tags = {
    Terraform   = "true"
    Application = upper(var.service)
    Environment = var.environment
  }
}
