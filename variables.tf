variable "aws_profile" {
  type        = string
  description = "AWS profile credentials setup locally"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default = "us-east-2"
}

variable "domain_name" {
    type = string
    description = "domain name of the website"
}

variable "cf_s3_origin_id" {
    type = string
    description = "s3 origin id for CF distribution"
}