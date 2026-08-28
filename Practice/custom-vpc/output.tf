output "ec2_public_ip" {
  value = aws_instance.custom_vpc_instance[*].public_ip
}

output "ec2_dns" {
  value = aws_instance.custom_vpc_instance[*].public_dns
}