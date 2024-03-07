data "aws_iam_policy_document" "instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "instance_role" {
  name = "${var.environment}-${var.service}-role"
  assume_role_policy = data.aws_iam_policy_document.instance_policy.json
}

resource "aws_iam_role_policy_attachment" "managed_ec2_readonly_attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "managed_ssm_service_attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "${var.environment}-${var.service}-instance-profile"
    role = aws_iam_role.instance_role.name
}

data "aws_iam_policy_document" "parameter_store_read_policy" {
  statement {
    sid     = "AllowReadOfParameterStore"
    actions = ["ssm:GetParameter"]
    effect  = "Allow"

    resources = [
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${local.parameter_store_path}"
    ]
  }

  statement {
    sid     = "AllowKMSDecryptForSSMKey"
    actions = ["kms:Decrypt"]
    effect  = "Allow"

    resources = [module.ssm_kms.key_arn]
  }
}

resource "aws_iam_role_policy" "parameter_store_read_policy" {
  role   = aws_iam_role.instance_role.name
  policy = data.aws_iam_policy_document.parameter_store_read_policy.json
}

data "aws_iam_policy_document" "ebs_encryption_policy" {
  statement {
    sid     = "AllowKMSActionstForEBSKey"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
    effect  = "Allow"

    resources = [module.ebs_kms.key_arn]
  }
}

resource "aws_iam_role_policy" "ebs_encryption_policy" {
  role   = aws_iam_role.instance_role.name
  policy = data.aws_iam_policy_document.ebs_encryption_policy.json
}

data "aws_iam_policy_document" "ssm_service_policy" {
  statement {
    sid       = "SSMKMSOperations"
    effect    = "Allow"
    resources = [local.security_ssm_kms_key_id]
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
  }

  statement {
    sid    = "SSMS3Operations"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${local.security_ssm_bucket_name}",
      "arn:aws:s3:::${local.security_ssm_bucket_name}/*"
    ]
    actions = [
      "s3:GetEncryptionConfiguration",
      "s3:PutObject",
      "s3:PutObjectACL"
    ]
  }
}

resource "aws_iam_role_policy" "ssm_service_policy" {
  role   = aws_iam_role.instance_role.name
  policy = data.aws_iam_policy_document.ssm_service_policy.json
}
