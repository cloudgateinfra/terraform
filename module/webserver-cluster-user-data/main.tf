# root module - webserver cluster
terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# defaults ok for dev
# prod/stage create separate vpcs/subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# locals set here; are called via "local." like above
locals {
  http_port    = 80
  // https_port   = 443
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_launch_configuration" "cluster" {
  # registered aws ami ubuntu 20.04 us west 2 image
  # custom ami image pre deploy script ami-0021a0edd14714e51
  image_id        = "ami-0974095049096f83a"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]

  # templates ami image with following services via script
  user_data = templatefile("${path.module}/install-services-ubuntu-20.04.sh", {
    server_port = var.server_port
    # ignore db for now until setup
    // db_address  = data.terraform_remote_state.db.outputs.address
    // db_port     = data.terraform_remote_state.db.outputs.port
  })

  # new instances will be created first
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cluster" {
  launch_configuration = aws_launch_configuration.cluster.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
  target_group_arns    = [aws_lb_target_group.asg.arn]
  health_check_type    = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  # instance refresh to roll out changes to the ASG
  # i.e. AMI image needs to be udpated
  # mitigates downtime significantly
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
}

resource "aws_lb" "cluster" { //rename bricks
  name               = var.cluster_name
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" { //rename bricks
  load_balancer_arn = aws_lb.cluster.arn
  port              = local.http_port
  protocol          = "HTTP"

  # default returns 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "asg" { // rename bricks
  name     = var.cluster_name
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" { // rename bricks
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

# for db module
 // data "terraform_remote_state" "db" {
 //   backend = "s3"
 //
 //   config = {
 //     bucket = var.db_remote_state_bucket
 //     key    = var.db_remote_state_key
 //     region = "us-west-2"
 //   }
 // }
