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

resource "hcloud_network" "main" {
  name     = var.network_name
  ip_range = var.ip_range

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "hcloud_network_subnet" "main" {
  for_each     = { for idx, subnet in var.subnets : subnet.name => subnet }
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = each.value.ip_range
}
