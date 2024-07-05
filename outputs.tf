output "azs" {
  value = data.aws_availability_zones.azs.names
}

output "public_ec2_ip_address" {
  value = aws_instance.public_ec2_instance.public_ip
}