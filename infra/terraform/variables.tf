variable "env_name" {
  type    = string
  default = "dev"
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
