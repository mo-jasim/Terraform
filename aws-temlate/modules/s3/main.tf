resource aws_s3_bucket my_bucket {
    count = var.bucket_count
    bucket = "${var.aws_s3_bucket_name}-${count.index + 1}"

    tags = {
      Name = "${var.aws_s3_bucket_name}-${count.index + 1}"
      Environment = var.env
    }
}