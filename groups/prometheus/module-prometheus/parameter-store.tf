resource "aws_ssm_parameter" "github_exporter_token_parameter" {
  name   = local.parameter_store_path
  type   = "SecureString"
  value  = var.github_exporter_token
  key_id = module.ssm_kms.key_arn
  tags   = local.default_tags
}
