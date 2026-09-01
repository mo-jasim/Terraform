resource "aws_vpc" "private_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.private_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.private_vpc.id

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "eice_sg" {
  name   = var.eice_sg_name
  vpc_id = aws_vpc.private_vpc.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.subnet_cidr]
  }

  tags = {
    Name = var.eice_sg_name
  }
}

resource "aws_ec2_instance_connect_endpoint" "eice" {
  subnet_id          = aws_subnet.private_subnet.id
  security_group_ids = [aws_security_group.eice_sg.id]

  tags = {
    Name = var.eice_name
  }
}