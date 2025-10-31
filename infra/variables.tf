variable "image" {
  type    = string
  default = "ubuntu-25-04-x64"
}
variable "env_name" {
  type    = string
  default = "dev"
}
variable "instance_size" {
  type    = string
  default = "s-1vcpu-512mb-10gb"
}
variable "public_key_path" {
  type    = string
  default = "../.ssh/key.pub"
}
variable "do_token" {
  type        = string
  description = "DigitalOcean API token. Do NOT commit this to source control. Provide via environment variable or an encrypted tfvars file."
  sensitive   = true
}

variable "spaces_secret_key" {
  type        = string
  description = "DigitalOcean Spaces secret key. Do NOT commit this to source control. Provide via environment variable or an encrypted tfvars file."
  sensitive   = true
}

variable "spaces_access_id" {
  type        = string
  description = "DigitalOcean Spaces access key ID. Do NOT commit this to source control. Provide via environment variable or an encrypted tfvars file."
  sensitive   = true
}
