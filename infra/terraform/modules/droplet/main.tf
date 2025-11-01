resource "digitalocean_droplet" "web" {
  image    = var.image
  name     = "${var.env_name}-web"
  size     = var.instance_size
  backups  = false
  region   = "sfo2"
  ssh_keys = [var.web_key_id]
  tags     = ["web"]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    systemctl enable nginx
    systemctl start nginx
    echo "<h1>Deployado via Terraform</h1>" > /var/www/html/index.html
  EOF
}

