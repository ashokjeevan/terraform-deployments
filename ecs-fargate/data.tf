data "aws_availability_zones" "azs" {
  state = "available"
}

# get current aws account id
data "aws_caller_identity" "current" {}

# get default route table id for vpc a
data "aws_route_table" "vpc_a_main_route_table" {
  vpc_id = module.ecs_vpc.vpc_id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}