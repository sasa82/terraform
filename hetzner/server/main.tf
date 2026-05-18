terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "main" {
  name       = "${var.server_name}-ssh-key"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_server" "main" {
  name        = var.server_name
  image       = var.server_image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.main.id]

  user_data = file("${path.module}/cloud-init/base-setup.yaml")

  labels = {
    environment = var.environment
    managed_by  = "terraform"
    role        = "virtualization-host"
  }
}

resource "hcloud_server_network" "main" {
  server_id  = hcloud_server.main.id
  network_id = var.network_id
  ip         = var.private_ip
}

resource "hcloud_firewall" "main" {
  name = "${var.server_name}-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.allowed_ssh_cidrs
  }

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall_attachment" "main" {
  firewall_id = hcloud_firewall.main.id
  server_ids  = [hcloud_server.main.id]
}
