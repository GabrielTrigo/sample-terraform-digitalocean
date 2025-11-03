# Configure the DigitalOcean Provider
provider "digitalocean" {
  token             = var.do_token
  spaces_secret_key = var.spaces_secret_key
  spaces_access_id  = var.spaces_access_id
}

module "droplet" {
  source     = "./modules/droplet"
  env_name   = var.env_name
  web_key_id = module.ssh.web_key_id

  providers = {
    digitalocean = digitalocean
  }
}

module "network" {
  source     = "./modules/network"
  env_name   = var.env_name
  droplet_id = module.droplet.droplet_id
  region     = "sfo2"
  providers = {
    digitalocean = digitalocean
  }
}

module "ssh" {
  source = "./modules/ssh"

  providers = {
    digitalocean = digitalocean
  }
}
