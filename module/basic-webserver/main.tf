provider "aws" {
  region = "us-east-2"
}

/* basic bash script using busybox built into linux
nohup which makes busybox always run never stop
add vpc security group and tell terra to use aws_security id */

resource "aws_instance" "web_server" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hey, looks like we are working!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    Name = "terraform-non-configurable-web-server"
  }
}

/* 0.0.0.0 allows all IPs
var is variable for to and from ports */

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
