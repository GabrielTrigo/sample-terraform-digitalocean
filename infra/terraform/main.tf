terraform {
  required_version = ">= 1.13.4"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.68.0"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://sfo3.digitaloceanspaces.com"
    }

    bucket = "trigus"
    key    = "terraform.tfstate"

    # Deactivate a few AWS-specific checks
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"
  }
}

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
}

module "network" {
  source     = "./modules/network"
  env_name   = var.env_name
  droplet_id = module.droplet.droplet_id
}

module "ssh" {
  source = "./modules/ssh"
}
