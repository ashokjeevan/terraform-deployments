# ec2 instance in public subnet vpc a
resource "aws_instance" "public_ec2_instance" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.ec2_instance_type
  subnet_id       = module.vpc_a.public_subnet_ids[0]
  security_groups = [aws_security_group.public_ec2_sg.id]
  key_name        = var.key_pair_name
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  EOF
  
  tags = {
    Name = "public_ec2_vpc_a"
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}

# ec2 instance in private subnet vpc a
resource "aws_instance" "private_ec2_instance" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.ec2_instance_type
  subnet_id       = module.vpc_a.private_subnet_ids[0]
  security_groups = [aws_security_group.private_ec2_sg.id]
  key_name        = var.key_pair_name

  tags = {
    Name = "private_ec2_vpc_b"
  }
  
  lifecycle {
    ignore_changes = [ tags ]
  }
}

# ec2 instance in private subnet vpc b
resource "aws_instance" "private_ec2_instance_vpc_b" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.ec2_instance_type
  subnet_id       = module.vpc_b.private_subnet_ids[0]
  security_groups = [aws_security_group.private_ec2_sg_vpc_b.id]
  key_name        = var.key_pair_name

  tags = {
    Name = "private_ec2_vpc_b"
  }

  lifecycle {
    ignore_changes = [ tags ]
  }
}