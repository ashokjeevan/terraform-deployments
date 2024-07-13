output "wordpress_ec2_isntance_public_ip" {
  value = aws_instance.wordpress_ec2.public_ip
}

output "wordpress_alb_dns" {
  value = module.wordpress_alb.alb_dns_name
}

output "wordpress_rds_instance_endpoint" {
  value = module.wordpress_rds_instance.rds_endpoint
}

output "wordpress_vpc_public_subnet_ids" {
  value = module.wordpress_vpc.public_subnet_ids
}

output "wordpress_vpc_private_subnet_ids" {
  value = module.wordpress_vpc.private_subnet_ids
}

output "wordpress_vpc_private_rds_subnet_ids" {
  value = module.wordpress_vpc.private_rds_subnet_ids
}