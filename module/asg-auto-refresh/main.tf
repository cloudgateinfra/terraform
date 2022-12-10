# automated prod asg refresh via static launch Template names
# refresh after AMI is baked/loaded into LTs via ansible/packer; run before auto testing via jenkins

provider "aws" {
  region = "us-west-2"
}
# prod vpc & subnets required
# you can also import subnets & vpc as resources but not recommended
data "aws_vpc" "prod" {
  filter {
      name   = "tag:Name"
      values = ["prod"]
    }
}

########################################
## refresh ASGs with newly baked AMIs ##
########################################

# usage: these local values are for the asgs desired capacity
# we use this technique to increase/decrease instances to refresh AMI via updated Launch Templates

# total of 6 prod asgs affected:
locals {
  desired_capacity_asg_app1_app2_web             = 2 // default 2 // set 4 refreshs new LT AMIs
  desired_capacity_asg_app1_app2_celery_click    = 1 // default 1 // set 2 refreshs new LT AMIs
  desired_capacity_asg_app1_app2_celerybeat      = 1 // default 1 // set 0 refreshs new LT AMIs
}

##############################
## Production ASG Resources ##
##############################

resource "aws_autoscaling_group" "prod_app_web" {
  name                   = "CodeDeploy_PROD-app-web-DG_d-Q5GW0K0NI"
  desired_capacity       = local.desired_capacity_asg_app_app_web
  min_size               = 0
  max_size               = 4
  launch_template {
    name    = "PROD-app-web-LT"
    version = "$Latest"
  }
  tag {
    key                 = "CodeDeployProvisioningDeploymentId"
    propagate_at_launch = true
    value               = "d-Q5GW0K0NI"
  }
  tag {
    key                 = "example:environment"
    propagate_at_launch = true
    value               = "prod"
  }
  tag {
    key                 = "example:role"
    propagate_at_launch = true
    value               = "web"
  }
  tag {
    key                 = "app:app"
    propagate_at_launch = true
    value               = "app-web"
  }
  tag {
    key                 = "app:asg"
    propagate_at_launch = true
    value               = "PROD-app-web-ASG"
  }
  tag {
    key                 = "app:env"
    propagate_at_launch = true
    value               = "prod"
  }
}

resource "aws_autoscaling_group" "prod_app_web" {
  name                   = "CodeDeploy_PROD-app-web-DG_d-G68RJXQMH"
  desired_capacity       = local.desired_capacity_asg_app_app_web
  min_size               = 0
  max_size               = 4
  launch_template {
    name    = "PROD-app-web-LT"
    version = "$Latest"
  }
  tag {
    key                 = "CodeDeployProvisioningDeploymentId"
    propagate_at_launch = true
    value               = "d-G68RJXQMH"
  }
  tag {
    key                 = "example:environment"
    propagate_at_launch = true
    value               = "prod"
  }
  tag {
    key                 = "example:role"
    propagate_at_launch = true
    value               = "web"
  }
  tag {
    key                 = "app:app"
    propagate_at_launch = true
    value               = "app-web"
  }
  tag {
    key                 = "app:asg"
    propagate_at_launch = true
    value               = "PROD-app-web-ASG"
  }
  tag {
    key                 = "app:env"
    propagate_at_launch = true
    value               = "prod"
  }
}

resource "aws_autoscaling_group" "prod_app_celerybeat" {
  name          = "PROD-app-celerybeat-ASG"
  desired_capacity = local.desired_capacity_asg_app_app_celerybeat
  min_size         = 0
  max_size         = 1
  launch_template {
    name    = "PROD-app-celerybeat-LT"
    version = "$Latest"
  }
  tag {
    key                 = "example:environment"
    propagate_at_launch = true
    value               = "prod"
  }
  tag {
    key                 = "example:role"
    propagate_at_launch = true
    value               = "web"
  }
  tag {
    key                 = "app:app"
    propagate_at_launch = true
    value               = "app-celerybeat"
  }
  tag {
    key                 = "app:asg"
    propagate_at_launch = true
    value               = "PROD-app-celerybeat-ASG"
  }
  tag {
    key                 = "app:env"
    propagate_at_launch = true
    value               = "prod"
  }
  # instance_refresh {
  #   strategy = "Rolling"
  #   preferences {
  #     min_healthy_percentage = 50
  #   }
  # }
}

resource "aws_autoscaling_group" "prod_app_celery" {
  name          = "PROD-app-celery-ASG"
  desired_capacity = local.desired_capacity_asg_app_app_celery_click
  min_size         = 0
  max_size         = 2
  launch_template {
    name      = "PROD-app-celery-LT"
    version = "$Latest"
  }
  tag {
    key                 = "example:environment"
    propagate_at_launch = true
    value               = "prod"
  }
  tag {
    key                 = "example:role"
    propagate_at_launch = true
    value               = "web"
  }
  tag {
    key                 = "app:app"
    propagate_at_launch = true
    value               = "app-celery"
  }
  tag {
    key                 = "app:asg"
    propagate_at_launch = true
    value               = "PROD-app-celery-ASG"
  }
  tag {
    key                 = "app:env"
    propagate_at_launch = true
    value               = "prod"
  }
  # instance_refresh {
  #   strategy = "Rolling"
  #   preferences {
  #     min_healthy_percentage = 50
  #   }
  # }
}

resource "aws_autoscaling_group" "prod_app_celerybeat" {
  name          = "PROD-app-celerybeat-ASG"
  desired_capacity = local.desired_capacity_asg_app_app_celerybeat
  min_size         = 0
  max_size         = 1
  launch_template {
    name    = "PROD-app-celerybeat-LT"
    version = "$Latest"
  }
  tag {
    key                 = "example:environment"
    propagate_at_launch = true
    value               = "prod"
  }
  tag {
    key                 = "example:role"
    propagate_at_launch = true
    value               = "web"
  }
  tag {
    key                 = "app:app"
    propagate_at_launch = true
    value               = "app-celerybeat"
  }
  tag {
    key                 = "app:asg"
    propagate_at_launch = true
    value               = "PROD-app-celerybeat-ASG"
  }
  tag {
    key                 = "app:env"
    propagate_at_launch = true
    value               = "prod"
  }
  # instance_refresh {
  #   strategy = "Rolling"
  #   preferences {
  #     min_healthy_percentage = 50
  #   }
  # }
}

resource "aws_autoscaling_group" "prod_app_celery" {
  name          = "PROD-app-celery-ASG"
  desired_capacity = local.desired_capacity_asg_app_app_celery_click
  min_size         = 0
  max_size         = 2
  launch_template {
    name      = "PROD-app-celery-LT"
    version = "$Latest"
  }
  tag {
    key                 = "example:environment"
    propagate_at_launch = true
    value               = "prod"
  }
  tag {
    key                 = "example:role"
    propagate_at_launch = true
    value               = "web"
  }
  tag {
    key                 = "app:app"
    propagate_at_launch = true
    value               = "app-celery"
  }
  tag {
    key                 = "app:asg"
    propagate_at_launch = true
    value               = "PROD-app-celery-ASG"
  }
  tag {
    key                 = "app:env"
    propagate_at_launch = true
    value               = "prod"
  }
  # instance_refresh {
  #   strategy = "Rolling"
  #   preferences {
  #     min_healthy_percentage = 50
  #   }
  # }
}
