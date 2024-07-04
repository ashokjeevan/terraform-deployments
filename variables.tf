# VPC CIDR
variable "vpc_cidr_range" {
  default = "10.0.0.0/16"
}

# Public Subnet CIDRs
variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

# Private Subnet CIDRs
variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "tf_vpc"
}

variable "igw_name" {
  type    = string
  default = "tf_igw"
}

variable "instance_type" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "my_ip" {
  type = string
}