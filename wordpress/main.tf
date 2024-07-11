# networking cpc
module "wordpress_vpc" {
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//vpc"

  vpc_cidr_block           = "10.0.0.0/16"
  vpc_name                 = "vpc_wp"
  create_igw               = true
  igw_name                 = "igw_wp"
  public_subnet_cidrs      = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  azs                      = data.aws_availability_zones.azs.names
}

module "wordpress_rds_instance" {
    source = "git::https://github.com/ashokjeevan/terraform-modules.git//rds"

    allocated_storage  = var.db_allocated_storage
    rds_db_name            = var.db_name
    rds_engine             = var.db_engine
    rds_engine_version     = var.db_engine_version
    rds_instance_class      = var.db_instance_type
    rds_db_username           = var.db_username
    rds_db_password           = var.db_password
    private_subnet_ids = module.wordpress_vpc.private_subnet_ids
    vpc_security_group_ids = [aws_security_group.private_rds_sg.id]
}

# wordpress ec2 instance
resource "aws_instance" "wordpress_ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.ec2_instance_type
  subnet_id              = module.wordpress_vpc.public_subnet_ids[0]
  vpc_security_group_ids = ["${aws_security_group.public_ec2_sg.id}"]
  user_data = base64encode(templatefile("user_data.tpl", {
    db_username      = var.db_username,
    db_user_password = var.db_password,
    db_name          = var.db_name,
    db_endpoint      = module.wordpress_rds_instance.rds_endpoint
  }))
  key_name = var.key_pair_name

  tags = {
    Name = "Wordpress_EC2"
  }

  root_block_device {
    volume_size = var.root_volume_size
  }
  depends_on = [module.wordpress_rds_instance]
}

module "wordpress_alb" {
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//alb"

  alb_name              = "wordpress-alb"
  alb_security_group_id = aws_security_group.public_alb_sg.id
  alb_subnets           = module.wordpress_vpc.public_subnet_ids
}

resource "aws_lb_target_group" "ec2_target_group" {
  name        = "alb-wp-ec2-target-group"
  vpc_id      = module.wordpress_vpc.vpc_id
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    enabled  = true
    path     = "/readme.html"
    protocol = "HTTP"
  }

}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.ec2_target_group.arn
  target_id        = aws_instance.wordpress_ec2.id
  port             = 80
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = module.wordpress_alb.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_target_group.arn
  }
}