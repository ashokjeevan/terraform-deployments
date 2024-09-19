# s3 bucket creation
resource "aws_s3_bucket" "trigger_bucket" {
  bucket = "trigger-bucket-sep2024"
}

# s3 block public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.trigger_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# destination s3 bucket
resource "aws_s3_bucket" "destination_bucket" {
  bucket = "destination-bucket-sept2024"
}

# s3 block public access
resource "aws_s3_bucket_public_access_block" "public_access_block_destination_bucket" {
  bucket = aws_s3_bucket.destination_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# create iam policy
resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda-s3-policy"
  path        = "/"
  description = "IAM policy for lambda to access S3"
  policy      = data.aws_iam_policy_document.lambda_s3_policy.json
}

# attach iam policy to iam role
resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

# lambda using aws module
module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.9.0"

  function_name = "parse-lambda"
  runtime       = "python3.12"
  description   = "Parse AWS Lambda function"
  handler       = "lambda_function.lambda_handler"
  source_path   = "./lambda_function.py"
  memory_size   = 128
  attach_policies = true
  number_of_policies = 1
  policies = [aws_iam_policy.lambda_s3_policy.arn]
  role_name = "parse-lambda-iam-role"
  
  environment_variables = {
    "SOURCE_BUCKET" = aws_s3_bucket.trigger_bucket.id
    "DESTINATION_BUCKET" = aws_s3_bucket.destination_bucket.id
  }
}