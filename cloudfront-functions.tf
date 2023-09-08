resource "aws_cloudfront_function" "redirect_apex_to_blog" {
  name    = "redirect_apex_www_www_blog_to_blog_cntechy_com"
  runtime = "cloudfront-js-1.0"
  comment = "redirect apex, www* , www.blog.* to blog.cntechy.com"
  publish = true
  code    = file("${path.module}/code/redirect.js")
}