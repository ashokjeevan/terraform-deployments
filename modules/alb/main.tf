resource "aws_lb" "load_balancer" {
  name               = var.alb_name
  internal           = var.is_internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.alb_security_group_id]
  subnets            = var.alb_subnets
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  idle_timeout                     = var.idle_timeout_seconds

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Name = var.alb_name
  }
}