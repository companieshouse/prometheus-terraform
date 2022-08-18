##
## Create the KMS key for Vault encryption along with a KMS alias
##
resource "aws_kms_key" "vault_key" {
  description              = "${var.service}-${var.environment} Backup Vault Key"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  tags = merge(
    local.default_tags,
    map(
      "Name", "${var.service}-${var.environment}-backup-vault-key"
    )
  )
}

resource "aws_kms_alias" "vault_key" {
  name          = "alias/${var.service}-${var.environment}-backup-vault-key"
  target_key_id = aws_kms_key.vault_key.key_id
}

##
## Create the Backup Vault using the KMS key
##
resource "aws_backup_vault" "vault" {
  name        = "${var.service}-${var.environment}-backup-vault"
  kms_key_arn = aws_kms_key.vault_key.arn

  tags = merge(
    local.default_tags,
    map(
      "Name", "${var.service}-${var.environment}-backup-vault"
    )
  )
}
