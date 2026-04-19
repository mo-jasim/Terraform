# EC2 Variable
variable "ec2_instance_name" {
  description = "This is used for renaming ec2 instance"
  default = "custom-vpc-server"
  type = string
}

variable "ec2_instance_type" {
  description = "AWS Instance Selections"
  default = "t3.micro"
  type = string
}

variable "ec2_volume_size" {
  description = "This is used for maintaining the volume size ec2 instance"
  default = 10
  type = number
}

variable "ec2_instance_count" {
  description = "Instance Count"
  default = 1
  type = number
}

variable "ec2_security_group_name" {
  description = "Security Group Name"
  default = "my-security-group"
  type = string
}

variable "ec2_running_state" {
  description = "This is used for maintaining the ec2 instance state"
  default = "stopped"
  type = string
}

variable "ssh_key_name" {
  description = "SSH Key Name"
  default = "dev"
  type = string
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "./terraform_key.pub"
}

variable "ec2_instance_ami" {
  description = "AWS AMI Selections"
  default = "ami-05d2d839d4f73aafb"
  type = string
}

# Remote Backend
variable "remote_bucket_name" {
  description = ""
  default = "mojasim-remote-s3-bucket"
  type = string
}

variable "remote_dynamodb_table" {
  description = ""
  default = "remote-backend-db"
  type = string
}

variable "remote_aws_region" {
  description = ""
  default = "ap-south-1"
  type = string
}

# VPC Variables
variable "vpc_name" {
  description = "Vpc name"
  default = "custom_vpc"
  type = string
}

variable "internet_gateway_name" {
  description = "internet_gateway_name"
  default = "custom_igw"
  type = string
}

variable "subnet_name" {
  description = "subnet_name"
  default = "public_subnet"
  type = string
}

variable "route_table_name" {
  description = "route_table_name"
  default = "public-route-table"
  type = string
}

variable "vpc_cidr_block" {
  description = ""
  default = "192.0.0.0/16"
  type = string
}

variable "subnet_cidr_block" {
  description = ""
  default = "192.0.1.0/24"
  type = string
}

variable "route_table_cidr_block" {
  description = ""
  default = "0.0.0.0/0"
  type = string
}