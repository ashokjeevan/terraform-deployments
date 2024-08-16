output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket.id
}

output "ddb_table" {
  value = aws_dynamodb_table.ddb_table.id
}