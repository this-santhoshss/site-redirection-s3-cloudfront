# Origin Access Control resource
resource "aws_cloudfront_origin_access_control" "root_redirects_app_policy" {
  name                              = "root to blog redirects OAC"
  description                       = "root to blog redirects OAC policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Default cache policy for Cloudfront
resource "aws_cloudfront_cache_policy" "root_redirects_default_cache_policy" {
  name        = "root_redirects-cache-policy"
  comment     = "root_redirects-cache-policy"
  default_ttl = 50
  max_ttl     = 100
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "all"
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip =  true
  }
}

#  Cloudfront Distribution for S3
resource "aws_cloudfront_distribution" "root_redirects_app_cf" {
  origin {
    domain_name = aws_s3_bucket.web_app_bucket.bucket_regional_domain_name
    origin_id   = var.cf_s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.root_redirects_app_policy.id
  }

  aliases = [var.domain_name, "www.${var.domain_name}", "www.blog.${var.domain_name}"]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.domain_name
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.cf_s3_origin_id
    cache_policy_id = aws_cloudfront_cache_policy.root_redirects_default_cache_policy.id

    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.redirect_apex_to_blog.arn
    }
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
        restriction_type = "none"
        locations = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.domain_cert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  depends_on = [ aws_acm_certificate.domain_cert, aws_route53_record.validation, aws_cloudfront_function.redirect_apex_to_blog ]
}