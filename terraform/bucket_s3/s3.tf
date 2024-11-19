resource "aws_s3_bucket" "s3-tfstate" {
  bucket = local.s3_name
  tags = {
    Name      = "s3-bucket-for-tfstate"
    yor_name  = "s3-tfstate"
    yor_trace = "cd7bf64d-f34a-4f68-8e44-0278c10d97c2"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-tfstate" {
  bucket              = aws_s3_bucket.s3-tfstate.id
  block_public_acls   = false
  block_public_policy = false
}
