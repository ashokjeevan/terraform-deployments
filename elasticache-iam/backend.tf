terraform {
  backend "s3" {
    bucket = "terraform-state-dev-august152024"
    key = "dev/tf-elasticache-iam"
    region = "ca-central-1"
    dynamodb_table = "terraform-state-lock-dev"
  }
}