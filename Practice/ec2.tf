resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "practice_key"
  public_key = file("./terraform_key.pub")
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "my_security_group" {
  name   = "my_security_group"
  vpc_id = aws_default_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_default_vpc.default.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_default_vpc.default.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_default_vpc.default.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_instance" "my_instance" {
  count         = 1
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3_micro"

  key_name = aws_key_pair.ssh_key_pair.ssh_key_pair.key_name

  vpc_security_group_ids = [aws_security_group.terraform_practice_security_group.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "My_ec2_instance"
  }
}

resource "aws_ec2_instance_state" "instance_state" {
  count       = 1
  instance_id = aws_instance.my_instance.id
  state       = "running"
}