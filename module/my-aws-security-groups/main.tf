# my personal aws security groups
provider "aws" {
  region = "us-west-2"
}
data "aws_vpc" "hub" {
  filter {
      name   = "tag:Name"
      values = ["hub"]
    }
}

# whitelist a windows work vm located in vpc for hub1/2 instances
# allows remote inbound access
resource "aws_security_group_rule" "allow_user1_work_win_vm" {
  type              = "ingress"
  from_port         = 0
  to_port           = 3389
  protocol          = "tcp"
  security_group_id = "sg-111111" // hub-sg-dc-111111111
  cidr_blocks       = ["10.111.0.0/24"] // my work win vm ipv4 address 10.111.0.111
}

# whitelist like above for my win vm for mysql hub win box security group
resource "aws_security_group_rule" "allow_user1_work_win_vm_2" {
  type              = "ingress"
  from_port         = 0
  to_port           = 3389
  protocol          = "tcp"
  security_group_id = "sg-222222" // hub-mysql-client
  cidr_blocks       = ["10.111.0.0/24"] // my work win vm ipv4 address 10.111.0.111
}
