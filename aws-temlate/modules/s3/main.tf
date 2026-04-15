resource aws_s3_bucket my_bucket {
    bucket = "${var.aws_s3_bucket_name}-${var.env}-${count.index}"

    count = var.bucket_count

    tags = {
      Name = "${var.aws_s3_bucket_name}-${count.index}"
    }
}