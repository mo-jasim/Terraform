# SSH Key Pair
resource "aws_key_pair" "ssh_key_pair" {
  key_name   = var.ssh_key_name
  public_key = file(var.public_key_path)
}


# Security Groups & Rules
# --- Public Instance Security Group ---
resource "aws_security_group" "public_instance_sg" {
  name        = var.public_sg_name
  description = "Security group for Public Instance (Bastion)"
  vpc_id      = aws_vpc.public_vpc.id

  tags = {
    Name = var.public_sg_name
  }
}

# Allow SSH from Internet (to public bastion instance)
resource "aws_vpc_security_group_ingress_rule" "public_allow_ssh_from_internet" {
  security_group_id = aws_security_group.public_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allow All Outbound Traffic from Public Instance
resource "aws_vpc_security_group_egress_rule" "public_allow_all_egress" {
  security_group_id = aws_security_group.public_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# --- Private Instance Security Group ---
resource "aws_security_group" "private_instance_sg" {
  name        = var.private_sg_name
  description = "Security group for Private Instance (Accessible ONLY from Public VPC)"
  vpc_id      = aws_vpc.private_vpc.id

  tags = {
    Name = var.private_sg_name
  }
}

# Allow SSH ONLY from Public VPC CIDR via Peering
resource "aws_vpc_security_group_ingress_rule" "private_allow_ssh_from_public_vpc" {
  security_group_id = aws_security_group.private_instance_sg.id
  cidr_ipv4         = var.public_vpc_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allow ICMP (Ping) from Public VPC CIDR for Peering connectivity testing
resource "aws_vpc_security_group_ingress_rule" "private_allow_ping_from_public_vpc" {
  security_group_id = aws_security_group.private_instance_sg.id
  cidr_ipv4         = var.public_vpc_cidr
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

# Allow All Outbound Traffic from Private Instance
resource "aws_vpc_security_group_egress_rule" "private_allow_all_egress" {
  security_group_id = aws_security_group.private_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 Instances
# 1. Public EC2 Instance (Placed in Public Subnet)
resource "aws_instance" "public_instance" {
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type

  key_name               = aws_key_pair.ssh_key_pair.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]

  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }

  tags = {
    Name = var.public_instance_name
  }
}

# State management for Public Instance
resource "aws_ec2_instance_state" "public_instance_state" {
  instance_id = aws_instance.public_instance.id
  state       = var.ec2_running_state
}

# 2. Private EC2 Instance (Placed in Private Subnet)
resource "aws_instance" "private_instance" {
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type

  key_name               = aws_key_pair.ssh_key_pair.key_name
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }

  tags = {
    Name = var.private_instance_name
  }
}

# State management for Private Instance
resource "aws_ec2_instance_state" "private_instance_state" {
  instance_id = aws_instance.private_instance.id
  state       = var.ec2_running_state
}