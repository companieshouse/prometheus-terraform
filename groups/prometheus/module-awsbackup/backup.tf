##
## Create a Backup plan
##
resource "aws_backup_plan" "plan" {
  count = var.backup_enable ? 1 : 0
  name  = "${var.service}-${var.environment}-backup-plan"
  rule {
    rule_name         = "${var.service}-${var.environment}-backup-rule"
    target_vault_name = aws_backup_vault.vault.id
    schedule          = var.backup_cron_schedule
    start_window      = var.backup_start_window_mins
    completion_window = var.backup_completion_window_mins

    lifecycle {
      delete_after    = var.backup_delete_after_days
    }

    recovery_point_tags = merge(
      local.default_tags,
      map(
        "Creator", "aws-backup"
      )
    )
  }

  tags = merge(
    local.default_tags,
    map(
      "Name", "${var.service}-${var.environment}-backup-plan"
    )
  )
}

resource "aws_backup_selection" "selection" {
  count        = var.backup_enable ? 1 : 0
  iam_role_arn = aws_iam_role.backup_service_role[0].arn
  name         = "${var.service}-${var.environment}-backup-selection"
  plan_id      = aws_backup_plan.plan[0].id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Environment"
    value = var.environment
  }

  condition {
    string_equals {
      key   = "aws:ResourceTag/Service"
      value = var.service
    }
  }
}

