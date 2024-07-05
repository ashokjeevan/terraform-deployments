module "alb" {
    source = "./modules/alb"

    alb_name = "ALB"
    alb_security_group_id = aws_security_group.alb_sg.id
    alb_subnets = module.vpc_a.public_subnet_ids
}