# S3 bucket to host website content
resource "aws_s3_bucket" "web_app_bucket" {
  bucket = var.domain_name

  tags = {
    Name        = "s3 bucket for root to blog"
  }
  force_destroy = true
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "s3_bucket_policy" {
  bucket = aws_s3_bucket.web_app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Static website configuration
resource "aws_s3_bucket_website_configuration" "web_app_bucket_config" {
  bucket = aws_s3_bucket.web_app_bucket.id

  index_document {
    suffix = "index.html"
  }
  
  error_document {
    key = "index.html"
  }
}

# Bucket policy for S3 bucket, only allow from cloudfront distribution
data "aws_iam_policy_document" "web_app_s3_bucket_policy" {
  statement {
    effect = "Allow"
    sid = "CloudFrontAllowRead"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web_app_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = [ "cloudfront.amazonaws.com"]
    }
    condition {
      test = "ArnEquals"
      values = [ aws_cloudfront_distribution.root_redirects_app_cf.arn ]
      variable = "aws:SourceArn"
    }
  }
}

# Associate bucket policy to S3 bucket
resource "aws_s3_bucket_policy" "web_app_policy" {
  bucket = aws_s3_bucket.web_app_bucket.id
  policy = data.aws_iam_policy_document.web_app_s3_bucket_policy.json
}
