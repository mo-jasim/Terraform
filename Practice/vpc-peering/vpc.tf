# 1. PUBLIC VPC (VPC-A) INFRASTRUCTURE
# Public VPC
resource "aws_vpc" "public_vpc" {
  cidr_block           = var.public_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.public_vpc_name
  }
}

# Internet Gateway for Public VPC
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.public_vpc.id

  tags = {
    Name = var.public_igw_name
  }
}

# Public Subnet (with auto public IP assignment)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.public_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = var.public_subnet_name
  }
}

# Public Route Table (Routes out to Internet via IGW)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.public_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_igw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# 2. PRIVATE VPC (VPC-B) INFRASTRUCTURE (No Internet Gateway)
# Private VPC
resource "aws_vpc" "private_vpc" {
  cidr_block           = var.private_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.private_vpc_name
  }
}

# Private Subnet (NO public IP on launch)
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.private_vpc.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name = var.private_subnet_name
  }
}

# Private Route Table (No Internet Gateway attached)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.private_vpc.id

  tags = {
    Name = var.private_route_table_name
  }
}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# 3. VPC PEERING CONNECTION & CROSS-VPC ROUTES
# VPC Peering Connection (Requester: Public VPC -> Accepter: Private VPC)
resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = aws_vpc.public_vpc.id   # Requester VPC ID
  peer_vpc_id = aws_vpc.private_vpc.id  # Accepter VPC ID
  auto_accept = true                    # Same account allows auto_accept

  tags = {
    Name = var.peering_connection_name
  }
}

# Route in Public Route Table pointing traffic for Private VPC CIDR -> Peering Connection
resource "aws_route" "public_to_private_peering_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = var.private_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Route in Private Route Table pointing traffic for Public VPC CIDR -> Peering Connection
resource "aws_route" "private_to_public_peering_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = var.public_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}