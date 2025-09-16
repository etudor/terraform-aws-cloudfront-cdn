variable "bucket_name" {
  description = "bucket name"
  type        = string
}

variable "domain_name" {
  description = "domain name"
  type        = string
}

variable "certificate_arn" {
  description = "CF Certificate ARN"
}

variable "allowed_origins" {
  description = "bucket allowed origins"
  type        = list(string)
}

variable "aliases" {
  description = "Additional CNAMEs (alternate domain names) for the CloudFront distribution"
  type        = list(string)
  default     = []
}
