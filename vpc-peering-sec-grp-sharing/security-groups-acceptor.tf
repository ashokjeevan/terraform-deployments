# create security group for private ec2 in acceptor account VPC
resource "aws_security_group" "private_ec2_sg_accepter" {
  provider = aws.accepter
  
  name        = "private-ec2-sg-accepter"
  description = "Security group for the private ec2 accepter"
  vpc_id      = module.vpc_acceptor.vpc_id

  tags = {
    Name = "private-ec2-sg-accepter"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public_ec2_accepter" {
  provider = aws.accepter
  
  security_group_id            = aws_security_group.private_ec2_sg_accepter.id
  cidr_ipv4                    = "0.0.0.0/0"
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_http_from_all_accepter"
  }
}