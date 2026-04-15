# AWS SSH Key Pair With Template Variable
resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.ssh_key_name}-terraform-key"
  public_key = file(var.public_key_path)
}

# VPS ID
resource "aws_default_vpc" "default" {}

# Security Group 
resource "aws_security_group" "my_security_group" {
  name        = var.ec2_security_group_name
  description = "Security group for default VPC"
  vpc_id      = aws_default_vpc.default.id
}

# SSH Port
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  # cidr_ipv4         = aws_default_vpc.default.cidr_block
  cidr_ipv4         = "0.0.0.0/0"
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
  count         = var.ec2_instance_count
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type

  key_name = aws_key_pair.my_key_pair.key_name

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = "gp3"
  }

  tags = { 
    Name = var.ec2_instance_name
    Environment = var.env
  }
}

# Instance State
resource "aws_ec2_instance_state" "my_instance_state" {
  count       = var.ec2_instance_count 
  
  instance_id = aws_instance.my_instance[count.index].id
  
  state       = var.ec2_running_state
}