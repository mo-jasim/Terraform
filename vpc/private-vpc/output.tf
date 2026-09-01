output "vpc_id" {
  value = aws_vpc.private_vpc.id
}

output "instance_id" {
  value = aws_instance.private_node.id
}

output "instance_private_ip" {
  value = aws_instance.private_node.private_ip
}

output "ssh_command" {
  value = "ssh -i ${replace(var.public_key_path, ".pub", "")} -o ProxyCommand=\"aws ec2-instance-connect open-tunnel --instance-id ${aws_instance.private_node.id}\" ubuntu@${aws_instance.private_node.private_ip}"
}