
resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name                              = var.name
  description                       = var.description
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cf_dist" {
  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
  }

  enabled = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  
  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }

  aliases = [
    var.domain_name
  ]

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    "Name" = "CF Dist ${var.origin_id}"
  }
}

resource "aws_route53_zone" "main" {
  name = "${var.domain_name}"
}

resource "aws_route53_record" "root_domain" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name = "${var.domain_name}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.cf_dist.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cf_dist.hosted_zone_id}"
    evaluate_target_health = false
  }
}

variable "name" {
  description = "cloudfront distribution name"
  type = string
}

variable "domain_name" {
  description = "public domain name"
  type = string
}

variable "description" {
  description = "cloudfront distribution description"
  type = string
}

variable "origin_id" {
  description = "bucket origin id"
  type = string
}

variable "certificate_arn" {
  description = "certificate arn"
  type = string
}

variable "origin_domain_name" {
  description = "bucket origin domain name"
  type = string
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.cf_dist.arn
}
