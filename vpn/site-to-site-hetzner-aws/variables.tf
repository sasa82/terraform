variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "aws_vpc_id" {
  description = "AWS VPC ID"
  type        = string
}

variable "aws_private_route_table_id" {
  description = "AWS private route table ID"
  type        = string
}

variable "aws_public_route_table_id" {
  description = "AWS public route table ID"
  type        = string
}

variable "hetzner_server_public_ip" {
  description = "Hetzner server public IP (VPN gateway)"
  type        = string
}

variable "hetzner_server_private_ip" {
  description = "Hetzner server private IP"
  type        = string
  default     = "10.0.1.1"
}

variable "hetzner_network_cidr" {
  description = "Hetzner private network CIDR"
  type        = string
  default     = "10.0.0.0/8"
}

variable "aws_network_cidr" {
  description = "AWS VPC CIDR"
  type        = string
  default     = "172.16.0.0/16"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key to configure Hetzner server"
  type        = string
  default     = "~/.ssh/id_rsa"
}
