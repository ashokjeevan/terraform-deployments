module "ecs_vpc" {
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//vpc"

  vpc_cidr_block           = "10.0.0.0/16"
  vpc_name                 = "vpc_ecs_nginx"
  create_igw               = true
  igw_name                 = "igw_nginx_fargate"
  public_subnet_cidrs      = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  azs                      = data.aws_availability_zones.azs.names
}

# ecs fargate cluster
resource "aws_ecs_cluster" "nginx_cluster" {
  name = "nginx-fargate-cluster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

# resource ecs task definition for nginx fargate
resource "aws_ecs_task_definition" "nginx_fargate" {
  family             = "nginx-fargate"
  cpu                = 512
  memory             = 1024
  # task_role_arn      = aws_iam_role.ecs_task_role.arn
  # execution_role_arn = aws_iam_role.ecs_task_role.arn
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<DEFINITION
[
  {
    "image": "public.ecr.aws/nginx/nginx:stable-alpine3.19-slim",
    "name": "nginx",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION

}

# create ecs service to deploy the aobve nginx task 
resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [module.ecs_vpc.public_subnet_ids[0], module.ecs_vpc.public_subnet_ids[1]]
    security_groups  = [aws_security_group.nginx_public_sg.id]
    assign_public_ip = true
  }
}

# security group for nginx service
resource "aws_security_group" "nginx_public_sg" {
  name        = "public_sg"
  description = "Security group for nginx container"
  vpc_id      = module.ecs_vpc.vpc_id

  tags = {
    Name = "public_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.nginx_public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.nginx_public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow_all_egress"
  }
}