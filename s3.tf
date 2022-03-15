resource "aws_s3_bucket" "bucket-test" {
  bucket = "bucket-csv"

  tags = {
    Name        = "My bucket"
    #Environment = "Dev"
  }
}
