module "vpc_a" {
  source = "./modules/vpc"

  vpc_cidr_block       = "10.0.0.0/16"
  vpc_name             = "vpc_a"
  create_igw           = true
  igw_name             = "igw_a"
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  azs                  = data.aws_availability_zones.azs.names
}

module "vpc_b" {
  source = "./modules/vpc"

  vpc_cidr_block       = "192.168.0.0/16"
  vpc_name             = "vpc_b"
  private_subnet_cidrs = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
  azs                  = data.aws_availability_zones.azs.names
}