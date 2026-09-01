# AWS S3 Bucket
resource "aws_s3_bucket" "remote-s3-bucket" {
    bucket = "mojasim-remote-s3-bucket"

    tags = {
      Name = "remote-s3-bucket"
    }
}

# DynamoDB
resource "aws_dynamodb_table" "remote-dynamodb-table" {
  name           = "remote-backend-db"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}