# create security group for public alb and ec2 in VPC A
resource "aws_security_group" "public_ec2_sg" {
  name        = "public-ec2-sg"
  description = "Security group for the public application load balancer"
  vpc_id      = module.vpc_a.vpc_id

  tags = {
    Name = "public-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public_ec2" {
  security_group_id            = aws_security_group.public_ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_http_from_alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_public_ec2" {
  security_group_id            = aws_security_group.public_ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
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

resource "aws_vpc_security_group_egress_rule" "allow_all_public_ec2" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_public_ec2"
  }
}

# private ec2 security group in VPC A
resource "aws_security_group" "private_ec2_sg" {
  name        = "private-ec2-sg"
  description = "Security group for the private EC2 instances"
  vpc_id      = module.vpc_a.vpc_id

  tags = {
    Name = "private-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_public_sg" {
  security_group_id            = aws_security_group.private_ec2_sg.id
  referenced_security_group_id = aws_security_group.public_ec2_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_ssh_from_public_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_private_sg" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_private_ec2"
  }
}

# ALB security group in VPC A
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc_a.vpc_id

  tags = {
    Name = "ALB-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_world" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_http_from_world"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_from_world" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_https_from_world"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_at_alb" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_from_alb"
  }
}

# private security group in VPC B
resource "aws_security_group" "private_ec2_sg_vpc_b" {
  name        = "private-ec2-sg-vpc-b"
  description = "Security group for the private EC2 instances"
  vpc_id      = module.vpc_b.vpc_id

  tags = {
    Name = "private-ec2-sg-vpc-b"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_vpc_b" {
  security_group_id = aws_security_group.private_ec2_sg_vpc_b.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_ssh_vpc_b"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_private_sg_vpc_v" {
  security_group_id = aws_security_group.private_ec2_sg_vpc_b.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_private_ec2"
  }
}