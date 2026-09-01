variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "private-vpc"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "subnet_name" {
  type    = string
  default = "private-subnet"
}

variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}

variable "route_table_name" {
  type    = string
  default = "private-rt"
}

variable "eice_sg_name" {
  type    = string
  default = "eice-security-group"
}

variable "eice_name" {
  type    = string
  default = "private-eic-endpoint"
}

variable "ubuntu_ami_owner" {
  type    = string
  default = "099720109477"
}

variable "ubuntu_ami_name_filter" {
  type    = string
  default = "ubuntu/images/hvm-ssd*/ubuntu-*-24.04-amd64-server-*"
}

variable "ubuntu_ami_virt_type" {
  type    = string
  default = "hvm"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_sg_name" {
  type    = string
  default = "private-instance-sg"
}

variable "instance_name" {
  type    = string
  default = "private-ec2-node"
}

variable "key_pair_name" {
  type    = string
  default = "terraform-deployer-key"
}

variable "public_key_path" {  
  type    = string
  default = "../../terraform_key.pub"
}