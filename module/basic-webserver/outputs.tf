/* output variable to grab EC2 public IP on APPLY ONLY
cause it needs to deploy to create an IP of course... DUH */

output "public_ip" {
  value = aws_instance.web_server.public_ip
  description = "The public IP address of the web server"
}

output "port" {
  value = var.server_port
  description = "The assigned port of the web server"
}

output "colon_string" {
  value = var.colon
  description = "literal colon string"
}
