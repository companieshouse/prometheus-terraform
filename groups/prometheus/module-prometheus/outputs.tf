output "instance_role_arn" {
  value = aws_iam_role.ec2_readonly.arn
}
