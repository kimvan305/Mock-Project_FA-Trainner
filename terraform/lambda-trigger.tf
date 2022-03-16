resource "aws_s3_bucket_notification" "lambda-trigger" {
  bucket = "${aws_s3_bucket.csv-bucket.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.count-row-csv-lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
    #filter_prefix       = "AWSLogs/"
    #filter_suffix       = ".log"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}