# ec2 instance
resource "aws_instance" "ec2_instance" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  subnet_id       = module.vpc_a.public_subnet_ids[0]
  security_groups = [aws_security_group.public_ec2_sg.id]
  key_name        = var.key_pair_name

  tags = {
    Name = "public ec2 instance"
  }
}