variable "vpc_cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "create_igw" {
  type    = bool
  default = false
}

variable "igw_name" {
  type    = string
  default = null
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = null
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}