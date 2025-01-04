data "aws_availability_zones" "azs" {
  state = "available"
}

# get current aws account id 
data "aws_caller_identity" "requestor" {}

# get current aws account id
data "aws_caller_identity" "accepter" {
  provider = aws.accepter
}

