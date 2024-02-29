module "ssm_kms" {
  source                  = "git@github.com:companieshouse/terraform-modules//aws/kms?ref=tags/1.0.235"
  kms_key_alias           = "${var.service}-${var.environment}/ssm"
  description             = "${var.service}-${var.environment} parameter store use"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  is_enabled              = true
  tags                    = local.default_tags
}
