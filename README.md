AWS Cloudfront CDN Basic Configuration

```terraform
provider "aws" {
  alias = "us"
  region = "us-east-1"
}

locals {
  public_buckets = toset([
    "images", // will create images bucket, and use domain images.example.com
    "static" // will create static bucket, and use domain static.example.com
  ])
}

# Find a certificate that is issued
data "aws_acm_certificate" "amazon_issued" {
  provider = aws.us
  domain   = "*.example.com"
  statuses = ["ISSUED"]
}

module "publicS3" {
  source          = "registry.terraform.io/etudor/cloudfront-cdn/aws"
  version         = "0.0.1"
  for_each        = local.public_buckets
  bucket_name     = each.value
  domain_name     = "${each.value}.example.com" // or your own cdn subdomain
  certificate_arn = data.aws_acm_certificate.amazon_issued.arn // or your issued certificate arn var.certificate_arn
}
```
