# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.igw_name
  }
}

# public subnets
resource "aws_subnet" "public_subnets" {
  count                   = var.public_subnet_cidrs != null ? length(var.public_subnet_cidrs) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${var.azs[count.index]}"
  }
}

# private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${var.azs[count.index]}"
  }
}

# Route table for public subnets
resource "aws_route_table" "public_route_table" {
  count  = var.public_subnet_cidrs != null ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
  tags = {
    Name = "public route table"
  }
}

# public subnet route table association
resource "aws_route_table_association" "public_route_table_association" {
  count          = var.public_subnet_cidrs != null ? length(var.public_subnet_cidrs) : 0
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table[0].id
}