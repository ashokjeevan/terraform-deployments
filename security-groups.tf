# create security group for public alb and ec2
resource "aws_security_group" "public_ec2_sg" {
  name        = "public-ec2-sg"
  description = "Security group for the public application load balancer"
  vpc_id      = module.vpc_a.vpc_id

  tags = {
    Name = "public-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public_ec2" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_http_public_ec2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_public_ec2" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_https_public_ec2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_public_ec2" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4         = var.my_ip
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_ssh_public_ec2"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_public_ec2" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_public_ec2"
  }
}