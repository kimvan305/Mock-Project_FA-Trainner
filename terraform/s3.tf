resource "aws_s3_bucket" "csv_test_bucket" {
  bucket = "csv-bucket"
  force_destroy = true

}
# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#   bucket = "${aws_s3_bucket.csv_test_bucket.id}"
#   policy = data.aws_iam_policy_document.allow_access_from_another_account.json
# }

# data "aws_iam_policy_document" "allow_access_from_another_account" {
#   statement {

#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket"
#     ]

#     resources = [
#       "arn:aws:s3:::${aws_s3_bucket.csv-bucket.arn}",
#       "arn:aws:s3:::${aws_s3_bucket.csv-bucket.arn}/*"
#     ]
#   }
# }
