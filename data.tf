data "aws_route53_zone" "domain_hosted_id" {
  name         = var.domain_name
}