output "instance_id" {
  description = "ID of EC2 instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.main.public_ip
}

output "instance_private_ip" {
  description = "Private IP of instance"
  value       = aws_instance.main.private_ip
}

output "instance_type" {
  description = "Type of EC2 instance"
  value       = aws_instance.main.instance_type
}
