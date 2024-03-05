data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "certificate" {
  count = local.create_ssl_certificate ? 0 : 1

  domain      = var.ssl_certificate_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}
