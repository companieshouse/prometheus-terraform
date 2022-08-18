##
## Lookup required data
##
data "aws_caller_identity" "current" {}

data "aws_iam_policy" "backup_service_policy" {
  count = var.backup_enable ? 1 : 0
  arn   = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

data "aws_iam_policy" "restore_service_policy" {
  count = var.backup_enable ? 1 : 0
  arn   = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

##
## Create an AssumeRole policy for the AWS Backup Service
##
data "aws_iam_policy_document" "backup_service_assume_role_doc" {
  count = var.backup_enable ? 1 : 0
  statement {
    sid     = "AssumeServiceRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

##
## PassRole permissions needed to be able to restore EC2 instance profiles
##
data "aws_iam_policy_document" "backup_service_pass_role_doc" {
  count = var.backup_enable ? 1 : 0
  statement {
    sid       = "AWSBackupPassRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = [
       "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2:*"
    ]
  }
}

##
## Create the IAM role
##
resource "aws_iam_role" "backup_service_role" {
  count              = var.backup_enable ? 1 : 0
  name               = "irol-${var.service}-${var.environment}-backup"
  description        = "Allows AWS Backup service to take scheduled backups"
  assume_role_policy = data.aws_iam_policy_document.backup_service_assume_role_doc[0].json

  tags = merge(
    local.default_tags,
    map(
      "Name", "irol-${var.service}-${var.environment}-backup"
    )
  )
}

##
## Attach the created policies
##
resource "aws_iam_role_policy" "backup_service_backup_policy" {
  count  = var.backup_enable ? 1 : 0
  policy = data.aws_iam_policy.backup_service_policy[0].policy
  role   = aws_iam_role.backup_service_role[0].name
}

resource "aws_iam_role_policy" "backup_service_restore_policy" {
  count  = var.backup_enable ? 1 : 0
  policy = data.aws_iam_policy.restore_service_policy[0].policy
  role   = aws_iam_role.backup_service_role[0].name
}

resource "aws_iam_role_policy" "backup_service_pass_role_policy" {
  count  = var.backup_enable ? 1 : 0
  policy = data.aws_iam_policy_document.backup_service_pass_role_doc[0].json
  role   = aws_iam_role.backup_service_role[0].name
}