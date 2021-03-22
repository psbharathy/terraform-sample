 provider "aws" {
   region = "us-east-1"
 }
# aws_cloudfront_distribution.aem_cf:
resource "aws_cloudfront_distribution" "aem_cf" {
  aliases = [
    var.domain_name
  ]
  comment             = var.domain_name
  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  tags                = {}
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress         = true
    default_ttl      = 86400
    max_ttl          = 31536000
    min_ttl          = 0
    smooth_streaming = false
    # target_origin_id       = "S3-reports-spa-prod/dist"
    target_origin_id       = var.aem_elb_origin_id
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      headers                 = []
      query_string            = false
      query_string_cache_keys = []

      cookies {
        forward           = "none"
        whitelisted_names = []
      }
    }

    lambda_function_association {
      event_type   = "origin-request"
      include_body = false
      lambda_arn   = var.lambda_arn
    }
  }
ordered_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress         = false
    default_ttl      = 86400
    max_ttl          = 31536000
    min_ttl          = 0
    path_pattern     = "/api/*"
    smooth_streaming = false
    # target_origin_id       = "ELB-artemis-prod-elb-1801398174"
    target_origin_id       = var.aem_elb_origin_id
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      headers = [
        "*",
      ]
      query_string            = true
      query_string_cache_keys = []

      cookies {
        forward           = "all"
        whitelisted_names = []
      }
    }
  }

  origin {
    domain_name = var.aem_elb_domain
    origin_id   = var.aem_elb_origin_id

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 60
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }
}
