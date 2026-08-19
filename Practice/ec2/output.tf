output "ec2_public_ip" {
  value = aws_instance.terraform_practice_instance[*].public_ip
}

output "ec2_dns" {
  value = aws_instance.terraform_practice_instance[*].public_dns
}