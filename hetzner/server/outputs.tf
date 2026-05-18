output "server_id" {
  description = "ID of the server"
  value       = hcloud_server.main.id
}

output "server_public_ip" {
  description = "Public IP of the server"
  value       = hcloud_server.main.ipv4_address
}

output "server_private_ip" {
  description = "Private IP of the server"
  value       = var.private_ip
}

output "server_name" {
  description = "Name of the server"
  value       = hcloud_server.main.name
}
