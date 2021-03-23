# aws_cloudfront_distribution.aem_cf:

resource "aws_cloudfront_origin_access_identity" "aem_cf" {
  comment = "aem-cf"
}

resource "aws_cloudfront_distribution" "aem_cf" {
   
    origin {
        domain_name = var.domain_name
        origin_id   = "ELB-${var.aem_elb_name}"
    }
  
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
            # target_origin_id       = "ELB-prod-elb-1801398174"
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

    restrictions {
        geo_restriction {
        restriction_type = "whitelist"
        locations        = ["US"]
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

}
