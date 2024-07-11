output "azs" {
  value = data.aws_availability_zones.azs.names
}

# output "public_ec2_ip_address" {
#   value = aws_instance.public_ec2_instance.public_ip
# }

output "vpc_a_id" {
  value = module.vpc_a.vpc_id
}

output "vpc_b_id" {
  value = module.vpc_b.vpc_id
}

output "vpc_peering_connector_accept_status" {
  value = module.vpc_peering_vpc_a_vpc_b
}

output "vpc_peering_connection_id" {
  value = module.vpc_peering_vpc_a_vpc_b
}