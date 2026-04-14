# AWS Region
provider "aws" {
  region = "ap-south-1"
}

# AWS SSH Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrsqpUaHSKd8a4xDXm6dBuVbr6SnshKpUkNGNvAiJMB mo-jasim@Mo-Jasim"
}

# VPS ID
resource "aws_default_vpc" "default" {}

# Security Group 
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Security group for default VPC"
  vpc_id      = aws_default_vpc.default.id
}

# SSH Port
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = aws_default_vpc.default.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Inbound Port Rules
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = aws_default_vpc.default.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Outbound Port Rules
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 Instance
resource "aws_instance" "my_instance" {
  # count = 2 # Create 2 instances
  # instance_state = "stopped" # Stop the instance
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t3.nano"

  key_name = aws_key_pair.my_key_pair.key_name

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  # EBS Storage
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "terra-auto-server"
  }
}

# Instance State
resource "aws_ec2_instance_state" "my_instance_state" {
  instance_id = aws_instance.my_instance.id
  state       = "stopped"
} 

# resource "aws_ec2_instance_state" "my_instance_state" {
#   for_each    = aws_instance.my_instance
#   instance_id = aws_instance.my_instance.id
#   state       = "stopped"
# }