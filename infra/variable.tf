variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "ssh_port" {
  description = "port for ssh"
  type        = number
  default = 22

}

variable "my_ip" {
  description = "your ip"
  type        = string
}