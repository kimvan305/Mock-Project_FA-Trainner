resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Sid" : ""
    }
  ]
}
EOF


  #assume_role_policy = "${file("iam/lambda-assume-policy.json")}"
}
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = "${file("iam/lambda-policy.json")}"
}


resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.count-row-csv-lambda.arn}"
  principal     = "s3.amazonaws.com"
  #source_arn= "arn:aws:s3:::${aws_s3_bucket.csv-bucket.arn}"
  source_arn    = "${aws_s3_bucket.csv_test_bucket.arn}"
  #source_arn    = "${aws_s3_bucket_notification.lambda-trigger.arn}"
}