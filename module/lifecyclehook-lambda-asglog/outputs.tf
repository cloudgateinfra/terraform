output "arn" {
  value = aws_autoscaling_group.asg_LogAutoScalingEvent_test.arn
  description = "displays arn value from aws of resource"
}
