# security group in requestor account for private ec2
resource "aws_security_group" "private_ec2_sg_requester" {
  name        = "private-ec2-sg-requester"
  description = "Security group for the private ec2 requester"
  vpc_id      = module.vpc_requestor.vpc_id

  tags = {
    Name = "private-ec2-sg-requester"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public_ec2_requester" {
  security_group_id            = aws_security_group.private_ec2_sg_requester.id
  referenced_security_group_id = "${data.aws_caller_identity.accepter.id}/${aws_security_group.private_ec2_sg_accepter.id}"
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"

  tags = {
    Name = "allow_http_from_all_requester"
  }
}