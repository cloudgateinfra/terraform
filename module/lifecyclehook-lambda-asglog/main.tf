# creates a stage ASG using any stage LT
# creates an IAM role using json EOF and ASG ARN, ASG AWS name & ACC ID #

provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "stage" {
  filter {
      name   = "tag:Name"
      values = ["stage"]
    }
}

resource "aws_autoscaling_group" "asg_LogAutoScalingEvent_test" {
  name                   = "asg-LogAutoScalingEvent-test"
  desired_capacity       = 1
  min_size               = 0
  max_size               = 1
  launch_template {
    name    = "STAGE-covid-LT" // using any stage LT for now...
    version = "$Latest"
  }
}

resource "aws_iam_policy" "policy_LogAutoScalingEvent_test" {
  name        = "policy-LogAutoScalingEvent-test"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:CompleteLifecycleAction",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:autoscaling:*:735361060997:autoScalingGroup:*:autoScalingGroupName/asg-lifecyclehook-test"
      },
    ]
  })
}

resource "aws_iam_role" "role_LogAutoScalingEvent_test" {
  name = "role-LogAutoScalingEvent-test"

  assume_role_policy = policy-LogAutoScalingEvent-test, AWSLambdaBasicExecutionRole

  tags = {
    tag-key = "role-LogAutoScalingEvent-test"
  }
}
