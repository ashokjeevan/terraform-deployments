# networking vpc
module "waf_vpc" {
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//vpc"

  vpc_cidr_block           = "10.0.0.0/16"
  vpc_name                 = "vpc_waf"
  create_igw               = true
  igw_name                 = "igw_waf"
  public_subnet_cidrs      = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  azs                      = data.aws_availability_zones.azs.names
}

