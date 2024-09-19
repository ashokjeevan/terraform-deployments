data "aws_availability_zones" "azs" {
  state = "available"
}

# get current aws account id
data "aws_caller_identity" "current" {}

# s3 bucket policy
data "aws_iam_policy_document" "lambda_s3_policy" {
  statement {
    sid = "AllowGetObjectFromSourceBucket"
    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.trigger_bucket.arn,
    ]
  }

  statement {
    sid = "AllowPutObjectToDestinationBucket"
    actions = [
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.destination_bucket.arn,
    ]
  }
}