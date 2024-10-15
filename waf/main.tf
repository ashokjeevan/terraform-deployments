locals {
  ec2_user_data = base64encode(templatefile("user_data.tpl", {
    environment = "Testing-WAF"
  }))
}

resource "aws_instance" "ec2_waf" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.ec2_instance_type
  subnet_id              = module.waf_vpc.public_subnet_ids[0]
  vpc_security_group_ids = ["${aws_security_group.public_ec2_sg.id}"]
  user_data = local.ec2_user_data
  key_name = var.key_pair_name

  tags = {
    Name = "EC2 for WAF"
  }

  root_block_device {
    volume_size = var.root_volume_size
  }
}

module "waf_alb" {
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//alb"

  alb_name              = "alb-waf"
  alb_security_group_id = aws_security_group.public_alb_sg.id
  alb_subnets           = module.waf_vpc.public_subnet_ids
}

resource "aws_lb_target_group" "ec2_target_group" {
  name        = "alb-wp-ec2-target-group"
  vpc_id      = module.waf_vpc.vpc_id
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
  }

}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.ec2_target_group.arn
  target_id        = aws_instance.ec2_waf.id
  port             = 80
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = module.waf_alb.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_target_group.arn
  }
}