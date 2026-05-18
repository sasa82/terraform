variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "network_name" {
  description = "Name of the private network"
  type        = string
  default     = "prod-network"
}

variable "ip_range" {
  description = "IP range for the entire network"
  type        = string
  default     = "10.0.0.0/8"
}

variable "network_zone" {
  description = "Network zone (eu-central, us-east, us-west)"
  type        = string
  default     = "eu-central"
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name     = string
    ip_range = string
  }))
  default = [
    {
      name     = "subnet-servers"
      ip_range = "10.0.1.0/24"
    },
    {
      name     = "subnet-vms"
      ip_range = "10.0.2.0/24"
    }
  ]
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "prod"
}
