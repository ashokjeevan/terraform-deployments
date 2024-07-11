data "aws_availability_zones" "azs" {
  state = "available"
}

# get latest amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# get current aws account id
data "aws_caller_identity" "current" {}

# for vpc peering
# get default route table id for vpc a
data "aws_route_table" "vpc_a_main_route_table" {
  vpc_id = module.vpc_a.vpc_id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# get default route table id for vpc b
data "aws_route_table" "vpc_b_main_route_table" {
  vpc_id = module.vpc_b.vpc_id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}