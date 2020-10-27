data "aws_iam_policy_document" "ec2_readonly" {
  statement {
    # sid = "1"
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
