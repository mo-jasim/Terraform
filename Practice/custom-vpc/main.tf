resource "aws_key_pair" "ssh_key_pair" {
  key_name = var.ssh_key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "custom_security_group" {
  name = var.ec2_security_group_name
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "custom_vpc_instance" {
  count = var.ec2_instance_count
  ami = var.ec2_instance_ami
  instance_type = var.ec2_instance_type

  key_name = aws_key_pair.ssh_key_pair.key_name

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [aws_security_group.custom_security_group.id]

  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }

  tags = { 
    Name = var.ec2_instance_name
  }
}

resource "aws_ec2_instance_state" "my_instance_state" {
  count       = var.ec2_instance_count 
  
  instance_id = aws_instance.custom_vpc_instance[count.index].id
  
  state       = var.ec2_running_state
}