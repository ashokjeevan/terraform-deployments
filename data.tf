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