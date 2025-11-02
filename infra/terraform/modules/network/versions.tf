terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      configuration_aliases = [digitalocean]
    }
  }
}