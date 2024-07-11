# ALB SG
resource "aws_security_group" "public_alb_sg" {
  name        = "public_alb_sg"
  description = "Security group for ALB"
  vpc_id      = module.wordpress_vpc.vpc_id

  tags = {
    Name = "public_alb_sg"
  }
}

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
  vpc_id      = module.wordpress_vpc.vpc_id

  tags = {
    Name = "public_ec2_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public_ec2" {
  security_group_id            = aws_security_group.public_ec2_sg.id
  referenced_security_group_id = aws_security_group.public_alb_sg.id
  #cidr_ipv4 = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  tags = {
    Name = "allow_http_from_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_public_ec2" {
  security_group_id            = aws_security_group.public_ec2_sg.id
  referenced_security_group_id = aws_security_group.public_alb_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_https_from_alb"
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

resource "aws_vpc_security_group_egress_rule" "allow_rds_egress_ec2" {
  security_group_id = aws_security_group.public_ec2_sg.id
  # referenced_security_group_id = aws_security_group.private_rds_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = {
    Name = "allow_rds_egress_from_ec2"
  }
}

# RDS security group
resource "aws_security_group" "private_rds_sg" {
  name        = "private_rds_sg"
  description = "Security group for the private RDS"
  vpc_id      = module.wordpress_vpc.vpc_id

  tags = {
    Name = "private_rds_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_rds_from_public_ec2" {
  security_group_id            = aws_security_group.private_rds_sg.id
  referenced_security_group_id = aws_security_group.public_ec2_sg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_3306_from_public_ec2"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_from_private_rds" {
  security_group_id = aws_security_group.private_rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_egress_from_private_rds"
  }
}