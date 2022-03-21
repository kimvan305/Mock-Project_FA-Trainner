resource "aws_s3_bucket" "apigw_bucket" {
  bucket        = "apigateway-bucket"
  force_destroy = true
  # acl = "public-read"

  # versioning {
  #   enabled = false
  # }
}