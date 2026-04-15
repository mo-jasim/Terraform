variable "ec2_instance_name" {
  description = "This is used for renaming ec2 instance"
  default = "terra-auto-server"
  type = string
}

variable "ec2_instance_type" {
  description = "AWS Instance Selections"
  default = "t3.nano"
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
  default = "running"
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
  default     = "../terraform_key.pub"
}

variable "ec2_instance_ami" {
  description = "AWS AMI Selections"
  default = "ami-05d2d839d4f73aafb"
  type = string
}

variable "env" {
  description = "Workspace"
  default = terraform.workspace
  type = string
}