# record for domain name validation
resource "aws_route53_record" "validation" {

  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_hosted_id.zone_id

}

# Route 53 record for root domain
resource "aws_route53_record" "staticapp" {
    zone_id = data.aws_route53_zone.domain_hosted_id.zone_id
    name    = var.domain_name
    type    = "A"
    allow_overwrite = true

    alias {
        name = aws_cloudfront_distribution.root_redirects_app_cf.domain_name
        zone_id = aws_cloudfront_distribution.root_redirects_app_cf.hosted_zone_id
        evaluate_target_health = false
    }
}

# Route 53 record for www domain
resource "aws_route53_record" "www_staticapp" {
    zone_id = data.aws_route53_zone.domain_hosted_id.zone_id
    name    = "www.${var.domain_name}"
    type    = "A"
    allow_overwrite = true

    alias {
        name = aws_cloudfront_distribution.root_redirects_app_cf.domain_name
        zone_id = aws_cloudfront_distribution.root_redirects_app_cf.hosted_zone_id
        evaluate_target_health = false
    }
}

#  Route 53 record for www blog domain
resource "aws_route53_record" "www_blog_staticapp" {
    zone_id = data.aws_route53_zone.domain_hosted_id.zone_id
    name    = "www.blog.${var.domain_name}"
    type    = "A"
    allow_overwrite = true

    alias {
        name = aws_cloudfront_distribution.root_redirects_app_cf.domain_name
        zone_id = aws_cloudfront_distribution.root_redirects_app_cf.hosted_zone_id
        evaluate_target_health = false
    }
}