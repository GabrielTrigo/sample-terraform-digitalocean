resource "digitalocean_ssh_key" "web_key" {
  name       = "${var.env_name}-ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPT4pl6dMqrrx1JHYPrQ4uqx8hwgG+wLeueW4Jk2EeVF gabri@DESKTOP-IOA25C5"
}
