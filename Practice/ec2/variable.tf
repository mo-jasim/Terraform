variable "ec2_instance_name" {
    default = "Terra-Practice"
    type = string
}

variable "ec2_instance_type" {
    default = "t3.micro"
    type = string
}

variable "ec2_instance_size" {
    default = 10
    type = number
}

variable "ec2_instance_count" {
    default = 1
    type = number
}

variable "ec2_instance_security_group_name" {
    default = "terraform-practice-group"
    type = string
}

variable "ec2_instance_running_state" {
    default = "running"
    type = string
}

variable "ec2_instance_key_name" {
    default = "terraform-practice"
    type = string
}

variable "ec2_instance_public_key_path" {
    default = "./terraform_key.pub"
    type = string
}

variable "ec2_instance_ami" {
    default = "ami-01a00762f46d584a1"
    type = string
}