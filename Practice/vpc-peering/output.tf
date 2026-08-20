# Public Instance Outputs
output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public_instance.id
}

output "public_instance_public_ip" {
  description = "Public IP address of the public EC2 instance (Bastion/Web)"
  value       = aws_instance.public_instance.public_ip
}

output "public_instance_private_ip" {
  description = "Private IP address of the public EC2 instance"
  value       = aws_instance.public_instance.private_ip
}

# Private Instance Outputs
output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = aws_instance.private_instance.id
}

output "private_instance_private_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = aws_instance.private_instance.private_ip
}

# VPC Peering Output
output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.peering.id
}

output "vpc_peering_status" {
  description = "Acceptance status of the VPC Peering connection"
  value       = aws_vpc_peering_connection.peering.accept_status
}
