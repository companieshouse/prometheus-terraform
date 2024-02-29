data "aws_iam_policy_document" "ec2_readonly" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "ec2_readonly" {
  name = "${var.environment}-${var.service}-ec2-read-only"
  assume_role_policy = data.aws_iam_policy_document.ec2_readonly.json
}

resource "aws_iam_role_policy_attachment" "ec2_readonly_attach" {
  role       = aws_iam_role.ec2_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_readonly" {
    name = "${var.environment}-${var.service}-ec2-read-only"
    role = aws_iam_role.ec2_readonly.name
}

data "aws_iam_policy_document" "parameter_store_read_policy" {
  statement {
    sid     = "AllowReadOfParameterStore"
    actions = ["ssm:GetParameter"]
    effect  = "Allow"

    resources = [
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${var.service}/${var.environment}/*"
    ]
  }

  statement {
    sid     = "AllowKMSDecrypt"
    actions = ["kms:Decrypt"]
    effect  = "Allow"

    resources = [module.ssm_kms.key_arn]
  }
}

resource "aws_iam_role_policy" "parameter_store_read_policy" {
  role   = aws_iam_role.ec2_readonly.name
  policy = data.aws_iam_policy_document.parameter_store_read_policy.json
}
