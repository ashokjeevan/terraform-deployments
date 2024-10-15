# ALB SG
resource "aws_security_group" "public_alb_sg" {
  name        = "public_alb_sg"
  description = "Security group for ALB"
  vpc_id      = module.waf_vpc.vpc_id

  tags = {
    Name = "public_alb_sg"
  }
}

# ALB ingress - HTTP 
resource "aws_vpc_security_group_ingress_rule" "allow_http_alb" {
  security_group_id = aws_security_group.public_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_http_alb"
  }
}

# ALB ingress - HTTPS
resource "aws_vpc_security_group_ingress_rule" "allow_https_alb" {
  security_group_id = aws_security_group.public_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_https_alb"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_alb" {
  security_group_id = aws_security_group.public_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_egress_from_alb"
  }
}

# create security group for public ec2
resource "aws_security_group" "public_ec2_sg" {
  name        = "public_ec2_sg"
  description = "Security group for the public ec2"
  vpc_id      = module.waf_vpc.vpc_id

  tags = {
    Name = "public_ec2_sg"
  }
}

# EC2 HTTP ingress - from public ALB SG
resource "aws_vpc_security_group_ingress_rule" "allow_http_public_ec2" {
  security_group_id            = aws_security_group.public_ec2_sg.id
  referenced_security_group_id = aws_security_group.public_alb_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_ingress_http_from_public_alb_sg"
  }
}

# EC@ HTTPS ingress - from public ALB SG
resource "aws_vpc_security_group_ingress_rule" "allow_https_public_ec2" {
  security_group_id            = aws_security_group.public_ec2_sg.id
  referenced_security_group_id = aws_security_group.public_alb_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_ingress_https_from_public_alb_sg"
  }
}

# EC2 SSH ingress - from my IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_public_ec2" {
  security_group_id            = aws_security_group.public_ec2_sg.id
  cidr_ipv4         = var.my_private_ip
  from_port         = 22
  to_port           = 22
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_ingress_https_from_my_ip"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_egress_public_ec2" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_egress_from_public_ec2"
  }
}