variable "aws_s3_bucket_name" {
  description = "S3 Bucket"
  default = "mojasim-practice"
  type = string
}

variable "bucket_count" {
  description = "S3 Bucket count"
  type = number
}

variable "env" {
  description = "Workspace"
  type = string
}