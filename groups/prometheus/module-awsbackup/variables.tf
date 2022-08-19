variable "service" {
  type        = string
  description = "The service name to be used when creating AWS resources"
}

variable "environment" {
  type        = string
  description = "The environment name to be used when creating AWS resources"
}

variable "backup_enable" {
  type        = bool
  description = "Controls whether the AWS Backup service should be configured for the deployment (true) or not (false)"
}

variable "backup_start_window_mins" {
  type        = number
  description = "The amount of time, in minutes, that AWS Backup has to start the backup process"
}

variable "backup_completion_window_mins" {
  type        = number
  description = "The amount of time, in minutes, that AWS Backup has to complete the backup process"
}

variable "backup_delete_after_days" {
  type        = number
  description = "The number of days after which backups will be deleted"
}

variable "backup_cron_schedule" {
  type        = string
  description = "The AWS cron schedule expression used to define when the configured backup plan should be executed"
}

variable "backup_instance_profile_list" {
  type        = list(string)
  description = "A list of instance profile ARNs that AWS Backup will be granted access to"
}
