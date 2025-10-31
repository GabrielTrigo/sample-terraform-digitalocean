terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
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
    region                      = "us-east-2"

    # Enable state locking with a lockfile
    use_lockfile = true
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token             = var.do_token
  spaces_secret_key = var.spaces_secret_key
  spaces_access_id  = var.spaces_access_id
}

# Create a web server
resource "digitalocean_droplet" "web" {
  image     = var.image
  name      = "${var.env_name}-web"
  size      = var.instance_size
  backups   = false
  region    = "sfo2"
  ssh_keys  = [digitalocean_ssh_key.web_key.id]
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    systemctl enable nginx
    systemctl start nginx
  EOF
}

resource "digitalocean_ssh_key" "web_key" {
  name       = "${var.env_name}-ssh-key"
  public_key = file(var.public_key_path)
}

resource "digitalocean_firewall" "web_firewall" {
  name = "${var.env_name}-web-firewall"

  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["189.39.99.144/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "0"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "0"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
