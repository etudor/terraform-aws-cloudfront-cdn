output "bucket_id" {
  value = module.public_buckets.bucket_id
}

output "bucket_arn" {
  value = module.public_buckets.bucket_arn
}

output "cloudfront_dist" {
  value = module.cloud_front.cloudfront_dist
}
