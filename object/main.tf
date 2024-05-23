resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = {
    "Name" = "Bucket ${var.bucket_name}"
  }
}

resource "aws_s3_bucket_cors_configuration" "public_bucket_cors" {
  bucket = aws_s3_bucket.s3_bucket.id
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE"]
    allowed_origins = var.allowed_origins
    expose_headers  = []
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_ownership_controls" "s3-acl-ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

variable "bucket_name" {
  description = "bucket name"
  type = string
}

variable "allowed_origins" {
  description = "bucket allowed origins"
  type = list(string)
}