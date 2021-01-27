module "label" {
  source      = "applike/label/aws"
  version     = "1.0.2"
  project     = var.project
  application = var.application
  family      = var.family
  environment = var.environment
}

locals {
  cluster_name = "${module.label.project}-${module.label.environment}-${module.label.family}"
  service_name = module.label.application
}

resource "aws_appautoscaling_target" "default" {
  count              = var.enabled ? 1 : 0
  service_namespace  = "ecs"
  resource_id        = "service/${local.cluster_name}/${local.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
}

resource "aws_appautoscaling_policy" "default" {
  count              = var.enabled ? 1 : 0
  name               = module.label.id
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.default[count.index].service_namespace
  resource_id        = aws_appautoscaling_target.default[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.default[count.index].scalable_dimension

  dynamic "target_tracking_scaling_policy_configuration" {
    for_each = var.target_tracking_configuration
    content {
      target_value       = lookup(target_tracking_scaling_policy_configuration.value, "target_value", null)
      scale_in_cooldown  = lookup(target_tracking_scaling_policy_configuration.value, "scale_in_cooldown", null)
      scale_out_cooldown = lookup(target_tracking_scaling_policy_configuration.value, "scale_out_cooldown", null)

      dynamic "predefined_metric_specification" {
        for_each = lookup(target_tracking_scaling_policy_configuration.value, "predefined_metric_specification", [])
        content {
          predefined_metric_type = lookup(target_tracking_scaling_policy_configuration.value, "predefined_metric_type", null)
          resource_label         = lookup(target_tracking_scaling_policy_configuration.value, "resource_label", null)
        }
      }
    }
  }
}