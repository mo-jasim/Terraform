resource "aws_key_pair" "terraform_practice_key-pair" {
    key_name = var.ec2_instance_key_name
    public_key = file(var.ec2_instance_public_key_path)
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "terraform_practice_security_group" {
  name = var.ec2_instance_security_group_name
  vpc_id = aws_default_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.terraform_practice_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.terraform_practice_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.terraform_practice_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraform_practice_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "terraform_practice_instance" {
  count = var.ec2_instance_count
  ami = var.ec2_instance_ami
  instance_type = var.ec2_instance_type

  key_name = aws_key_pair.terraform_practice_key-pair.key_name
  
  vpc_security_group_ids = [aws_security_group.terraform_practice_security_group.id]

  root_block_device {
    volume_size = var.ec2_instance_size
    volume_type = "gp3"
  }

  tags = {
    Name = var.ec2_instance_name
  }
}

resource "aws_ec2_instance_state" "instance_state" {
  count = var.ec2_instance_count

  instance_id = aws_instance.terraform_practice_instance[count.index].id

  state = var.ec2_instance_running_state
}