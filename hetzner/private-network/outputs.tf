output "network_id" {
  description = "ID of the private network"
  value       = hcloud_network.main.id
}

output "network_name" {
  description = "Name of the private network"
  value       = hcloud_network.main.name
}

output "network_ip_range" {
  description = "IP range of the network"
  value       = hcloud_network.main.ip_range
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = { for k, v in hcloud_network_subnet.main : k => v.id }
}

output "subnet_ip_ranges" {
  description = "Map of subnet names to IP ranges"
  value       = { for k, v in hcloud_network_subnet.main : k => v.ip_range }
}
