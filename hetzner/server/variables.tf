variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "server_name" {
  description = "Name of the server"
  type        = string
  default     = "test-server"
}

variable "server_image" {
  description = "OS image"
  type        = string
  default     = "ubuntu-22.04"
}

variable "server_type" {
  description = "Server type"
  type        = string
  default     = "cx22"
}

variable "location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "nbg1"
}

variable "network_id" {
  description = "Private network ID to attach server to"
  type        = number
}

variable "private_ip" {
  description = "Fixed private IP for this server within the network"
  type        = string
  default     = "10.0.1.1"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_cidrs" {
  description = "IPs allowed to SSH into the server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "test"
}
