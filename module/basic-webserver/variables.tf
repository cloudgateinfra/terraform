variable "colon" {
  description = "literal string colon ie ':'"

  type = string
  default = ":"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"

  type = number
  default = 8080 // comment out to manually enter port on plan apply
}
