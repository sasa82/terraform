output "vpn_connection_id" {
  description = "VPN connection ID"
  value       = aws_vpn_connection.hetzner_aws.id
}

output "vpn_gateway_id" {
  description = "Virtual Private Gateway ID"
  value       = aws_vpn_gateway.main.id
}

output "tunnel1_address" {
  description = "VPN tunnel 1 outside IP address"
  value       = aws_vpn_connection.hetzner_aws.tunnel1_address
}

output "tunnel2_address" {
  description = "VPN tunnel 2 outside IP address"
  value       = aws_vpn_connection.hetzner_aws.tunnel2_address
}

output "tunnel1_preshared_key" {
  description = "VPN tunnel 1 preshared key"
  value       = aws_vpn_connection.hetzner_aws.tunnel1_preshared_key
  sensitive   = true
}

output "tunnel2_preshared_key" {
  description = "VPN tunnel 2 preshared key"
  value       = aws_vpn_connection.hetzner_aws.tunnel2_preshared_key
  sensitive   = true
}
