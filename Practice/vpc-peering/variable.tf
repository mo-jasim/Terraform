# General & SSH Variables
variable "availability_zone" {
  description = "AWS Availability Zone"
  type        = string
  default     = "ap-south-1a"
}

variable "ssh_key_name" {
  description = "SSH Key Name in AWS"
  type        = string
  default     = "peering-practice-ssh"
}

variable "public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "../terraform_key.pub"
}

variable "ec2_instance_ami" {
  description = "Ubuntu AMI ID for ap-south-1"
  type        = string
  default     = "ami-01a00762f46d584a1"
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_volume_size" {
  description = "EBS Volume size in GB"
  type        = number
  default     = 10
}

variable "ec2_volume_type" {
  description = "EBS Volume type"
  type        = string
  default     = "gp3"
}

variable "ec2_running_state" {
  description = "EC2 Instance state"
  type        = string
  default     = "running"
}

# Public VPC (VPC-A) Variables
variable "public_vpc_name" {
  description = "Name tag for Public VPC"
  type        = string
  default     = "public-vpc-a"
}

variable "public_vpc_cidr" {
  description = "CIDR block for Public VPC (Non-overlapping)"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_name" {
  description = "Name tag for Public Subnet"
  type        = string
  default     = "public-subnet-a"
}

variable "public_subnet_cidr" {
  description = "CIDR block for Public Subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "public_route_table_name" {
  description = "Name tag for Public Route Table"
  type        = string
  default     = "public-rt-a"
}

variable "public_igw_name" {
  description = "Name tag for Internet Gateway"
  type        = string
  default     = "public-igw-a"
}

variable "public_sg_name" {
  description = "Security Group name for Public Instance"
  type        = string
  default     = "public-instance-sg"
}

variable "public_instance_name" {
  description = "Name tag for Public EC2 Instance (Bastion/Web)"
  type        = string
  default     = "public-server-a"
}

# Private VPC (VPC-B) Variables
variable "private_vpc_name" {
  description = "Name tag for Private VPC"
  type        = string
  default     = "private-vpc-b"
}

variable "private_vpc_cidr" {
  description = "CIDR block for Private VPC (Non-overlapping)"
  type        = string
  default     = "10.2.0.0/16"
}

variable "private_subnet_name" {
  description = "Name tag for Private Subnet"
  type        = string
  default     = "private-subnet-b"
}

variable "private_subnet_cidr" {
  description = "CIDR block for Private Subnet"
  type        = string
  default     = "10.2.1.0/24"
}

variable "private_route_table_name" {
  description = "Name tag for Private Route Table"
  type        = string
  default     = "private-rt-b"
}

variable "private_sg_name" {
  description = "Security Group name for Private Instance"
  type        = string
  default     = "private-instance-sg"
}

variable "private_instance_name" {
  description = "Name tag for Private EC2 Instance"
  type        = string
  default     = "private-server-b"
}

# VPC Peering Connection Name
variable "peering_connection_name" {
  description = "Name tag for the VPC Peering Connection"
  type        = string
  default     = "vpc-a-to-vpc-b-peering"
}