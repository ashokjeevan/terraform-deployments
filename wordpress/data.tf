data "aws_availability_zones" "azs" {
  state = "available"
}

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

data "aws_caller_identity" "current" {}

# get default route table (for private subnets)
data "aws_route_table" "wodpress_vpc_main_route_table" {
  vpc_id = module.wordpress_vpc.vpc_id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}