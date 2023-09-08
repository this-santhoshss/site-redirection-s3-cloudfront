# ACM cert for the domain name validation
resource "aws_acm_certificate" "domain_cert" {
  provider = aws.us_east_1 
  domain_name       = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = [
    "www.${var.domain_name}", "www.blog.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# validating the certs
resource "aws_acm_certificate_validation" "domain_cert_validation" {
  provider = aws.us_east_1 
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}