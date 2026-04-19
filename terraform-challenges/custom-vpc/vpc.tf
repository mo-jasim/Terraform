# Custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
      Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
      Name = var.internet_gateway_name
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"

  tags = {
      Name = var.subnet_name
  }
}

# Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
      cidr_block = var.route_table_cidr_block
      gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
      Name = var.route_table_name
  }
}

# Route Table Association
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}