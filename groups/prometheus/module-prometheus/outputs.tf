output "instance_arns" {
  value = [for data in aws_instance.prometheus_instance : data.arn]
}

output "instance_role_arn" {
  value = aws_iam_role.ec2_readonly.arn
}
