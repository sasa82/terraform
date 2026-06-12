terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_customer_gateway" "hetzner" {
  bgp_asn    = 65000
  ip_address = var.hetzner_server_public_ip
  type       = "ipsec.1"

  tags = {
    Name      = "hetzner-customer-gateway"
    ManagedBy = "terraform"
  }
}

resource "aws_vpn_gateway" "main" {
  vpc_id = var.aws_vpc_id

  tags = {
    Name      = "hetzner-aws-vpn-gateway"
    ManagedBy = "terraform"
  }
}

resource "aws_vpn_connection" "hetzner_aws" {
  customer_gateway_id = aws_customer_gateway.hetzner.id
  vpn_gateway_id      = aws_vpn_gateway.main.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name      = "hetzner-aws-vpn-connection"
    ManagedBy = "terraform"
  }
}

resource "aws_vpn_connection_route" "hetzner_network" {
  vpn_connection_id      = aws_vpn_connection.hetzner_aws.id
  destination_cidr_block = var.hetzner_network_cidr
}

resource "aws_route" "hetzner_vpn_private" {
  route_table_id         = var.aws_private_route_table_id
  destination_cidr_block = var.hetzner_network_cidr
  gateway_id             = aws_vpn_gateway.main.id
}

resource "aws_route" "hetzner_vpn_public" {
  route_table_id         = var.aws_public_route_table_id
  destination_cidr_block = var.hetzner_network_cidr
  gateway_id             = aws_vpn_gateway.main.id
}

resource "aws_vpn_gateway_route_propagation" "private" {
  vpn_gateway_id = aws_vpn_gateway.main.id
  route_table_id = var.aws_private_route_table_id
}

resource "aws_vpn_gateway_route_propagation" "public" {
  vpn_gateway_id = aws_vpn_gateway.main.id
  route_table_id = var.aws_public_route_table_id
}

resource "null_resource" "hetzner_vpn_setup" {
  depends_on = [aws_vpn_connection.hetzner_aws]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = var.hetzner_server_public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update -y && apt-get install -y strongswan strongswan-pki || true",
      "ufw allow 500/udp",
      "ufw allow 4500/udp",
      "printf 'config setup\\n    charondebug=\"ike 2, knl 2, cfg 2\"\\nconn hetzner-aws\\n    authby=secret\\n    left=%%defaultroute\\n    leftid=${var.hetzner_server_public_ip}\\n    leftsubnet=${var.hetzner_network_cidr}\\n    right=${aws_vpn_connection.hetzner_aws.tunnel1_address}\\n    rightsubnet=${var.aws_network_cidr}\\n    ike=aes256-sha256-modp1024!\\n    esp=aes256-sha256!\\n    keyingtries=%%forever\\n    ikelifetime=28800s\\n    lifetime=3600s\\n    dpddelay=30s\\n    dpdtimeout=120s\\n    dpdaction=restart\\n    auto=start\\n    type=tunnel\\n' > /etc/ipsec.conf",
      "echo '${var.hetzner_server_public_ip} ${aws_vpn_connection.hetzner_aws.tunnel1_address} : PSK \"${aws_vpn_connection.hetzner_aws.tunnel1_preshared_key}\"' > /etc/ipsec.secrets",
      "ip route add ${var.aws_network_cidr} via ${var.hetzner_server_public_ip} dev eth0 src ${var.hetzner_server_private_ip} || true",
      "systemctl enable strongswan-starter",
      "systemctl restart strongswan-starter",
      "sleep 5",
      "ipsec status"
    ]
  }
}
