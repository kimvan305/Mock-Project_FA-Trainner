locals{
    lambda_zip_location="apigateway_lambda.zip"
}
data "archive_file" "apigateway_lambda" {
  type        = "zip"
  source_file = "src/apigateway_lambda.py"
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "apigateway_lambda" {
  filename      = "${local.lambda_zip_location}"#"${local.lambda_zip_location}"
  function_name = "apigateway_lambda"
  role          = aws_iam_role.apigateway_lambda_role.arn
  handler       = "apigateway_lambda.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #source_code_hash = "${base64sha256(file("${local.lambda_zip_location}"))}"
  #source_code_hash = filebase64sha256("${local.lambda_zip_location}")
  source_code_hash = data.archive_file.apigateway_lambda.output_base64sha256
  timeout = 120
  runtime = "python3.7"


}
resource "aws_iam_role" "apigateway_lambda_role" {
  name = "apigateway_lambda_role"
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
resource "aws_iam_role_policy" "apigateway_lambda_policy" {
  name = "apigateway_lambda_policy"
  role = aws_iam_role.apigateway_lambda_role.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:UpdateItem"
      ],
      "Effect": "Allow",
      "Resource":  "arn:aws:dynamodb:::${aws_dynamodb_table.count_row_csv.arn}"
    },
    {
      "Sid": "",
      "Resource": "*",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBuckets",
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.apigw_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.apigw_bucket.id}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apigateway_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.mydemo_api.execution_arn}/*/*/*"
}