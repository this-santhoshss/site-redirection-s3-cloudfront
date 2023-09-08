This is a Terraform project which shows how to set up site redirects using CloudFront, S3 and Terraform. We will also serve it through a domain registered in Route 53. 

# Getting started

1. Rename the file `terraform.tfvars.sample` to `terraform.tfvars` 

2. Modify the values in the file to match your project. 

3. Run the terraform commands. 

The full step-by-step guide on how the project is available at [blog.cntechy.com](https://blog.cntechy.com/how-to-set-up-site-redirects-in-cloudfront-using-terraform)

# Tools used

IaC tool: Terraform.

AWS services: S3, Cloudfront, Cloudfront functions, Route 53, ACM.

# Final Result

The redirects you have set up will function correctly.

After the successful creation of all the resources, in my case, if you navigate to any of the domains cntechy.com, www.cntechy.com, www.blog.cntechy.com, you will be redirected to the blog.cntechy.com.