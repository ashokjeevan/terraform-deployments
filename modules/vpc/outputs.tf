output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "default_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}