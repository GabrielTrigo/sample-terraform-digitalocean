variable "image" {
  type    = string
  default = "ubuntu-25-04-x64"
}

variable "instance_size" {
  type    = string
  default = "s-1vcpu-512mb-10gb"
}

variable "env_name" {
  type    = string
  default = "dev"
}

variable "web_key_id" {
  type = number
}
