module "vpc_a" {
  # source = "./modules/vpc"
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//vpc"

  vpc_cidr_block       = "10.0.0.0/16"
  vpc_name             = "vpc_a"
  create_igw           = true
  igw_name             = "igw_a"
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  azs                  = data.aws_availability_zones.azs.names
}

module "vpc_b" {
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//vpc"

  vpc_cidr_block       = "192.168.0.0/16"
  vpc_name             = "vpc_b"
  private_subnet_cidrs = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
  azs                  = data.aws_availability_zones.azs.names
}

module "vpc_peering_vpc_a_vpc_b" {
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//vpc-peering"
  aws_account_id = data.aws_caller_identity.current.account_id
  target_vpc_id = module.vpc_a.vpc_id
  requestor_vpc_id = module.vpc_b.vpc_id
  peering_connection_auto_accept = true
}

# add route to vpc b in vpc_a route table
resource "aws_route" "route_to_vpc_a" {
  route_table_id            = data.aws_route_table.vpc_b_main_route_table.id
  destination_cidr_block    = module.vpc_a.vpc_cidr_block
  vpc_peering_connection_id = module.vpc_peering_vpc_a_vpc_b.vpc_peering_connection_id
  depends_on                = [data.aws_route_table.vpc_b_main_route_table]
}

# add route to vpc a in vpc_b route table
resource "aws_route" "route_to_vpc_b" {
  route_table_id            = data.aws_route_table.vpc_a_main_route_table.id
  destination_cidr_block    = module.vpc_b.vpc_cidr_block
  vpc_peering_connection_id = module.vpc_peering_vpc_a_vpc_b.vpc_peering_connection_id
  depends_on                = [data.aws_route_table.vpc_a_main_route_table]
}