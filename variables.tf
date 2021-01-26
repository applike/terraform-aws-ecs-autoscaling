variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "project" {
  type        = string
  default     = ""
  description = "Project, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT'"
}

variable "family" {
  type        = string
  default     = ""
  description = "Family, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "application" {
  type        = string
  default     = ""
  description = "Solution application, e.g. 'app' or 'jenkins'"
}

variable "max_capacity" {
  type        = number
  default     = null
  description = "The max capacity of the scalable target"
}

variable "min_capacity" {
  type        = number
  default     = null
  description = "The min capacity of the scalable target"
}

variable "target_tracking_configuration" {
  type = list(object({
    target_value       = number
    scale_in_cooldown  = number
    scale_out_cooldown = number
    predefined_metric_specification = list(object({
      predefined_metric_type = string
      resource_label         = string
    }))
  }))
  description = "A target tracking policy, requires policy_type = 'TargetTrackingScaling'"
  default     = []
}
