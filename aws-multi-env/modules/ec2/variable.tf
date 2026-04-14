variable "ec2_instance_name" {
  description = "This is used for renaming ec2 instance"
  default = "terra-auto-server"
  type = string
}

variable "ec2_volume_size" {
  description = "This is used for maintaining the volume size ec2 instance"
  default = 10
  type = number
}

variable "ec2_running_state" {
  description = "This is used for maintaining the ec2 instance state"
  default = "running"
  type = string
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "./terraform_key.pub"
}

variable "env" {
  description = "This is used for changing key name"
  default = "dev"
  type = string
}