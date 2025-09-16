module "public_buckets" {
  source          = "./object"
  bucket_name     = var.bucket_name
  allowed_origins = var.allowed_origins
}

module "cloud_front" {
  source             = "./cloudfront"
  domain_name        = var.domain_name
  name               = module.public_buckets.bucket_id
  certificate_arn    = var.certificate_arn
  description        = "CF Distribution for ${module.public_buckets.bucket_id}"
  origin_domain_name = module.public_buckets.bucket_regional_domain_name
  origin_id          = module.public_buckets.bucket_id
  depends_on         = [module.public_buckets]
  aliases            = var.aliases
}

module "cdn-oac-bucket-policy-primary" {
  source         = "./cdn-oac"
  bucket_id      = module.public_buckets.bucket_id
  bucket_arn     = module.public_buckets.bucket_arn
  cloudfront_arn = module.cloud_front.cloudfront_arn
}

