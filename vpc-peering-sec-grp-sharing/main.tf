# vpc in the original account # acceptor account
module "vpc_acceptor" {
  providers = {
   aws = aws.accepter
  }
  
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//vpc"

  vpc_cidr_block       = "10.0.0.0/16"
  vpc_name             = "vpc_acceptor"
  create_igw           = false
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  azs                  = data.aws_availability_zones.azs.names
}

# vpc in chinnu's account # requestor account
module "vpc_requestor" {
  source = "git::https://github.com/ashokjeevan/terraform-modules.git//vpc"

  vpc_cidr_block       = "192.168.0.0/16"
  vpc_name             = "vpc_requestor"
  create_igw           = false
  private_subnet_cidrs = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
  azs                  = data.aws_availability_zones.azs.names
}

# vpc peering requestor
resource "aws_vpc_peering_connection" "requestor_vpc" {
    peer_owner_id = data.aws_caller_identity.accepter.account_id
    peer_vpc_id = module.vpc_acceptor.vpc_id
    vpc_id = module.vpc_requestor.vpc_id
    peer_region = "ca-central-1"
    auto_accept = false

    tags = {
        Name = "Requestor"
    }
}

# vpc peering acceptor
resource "aws_vpc_peering_connection_accepter" "requestor_vpc" {
  provider = aws.accepter

  vpc_peering_connection_id = aws_vpc_peering_connection.requestor_vpc.id
  auto_accept = true

  tags = {
        Name = "Acceptor"
    }
}