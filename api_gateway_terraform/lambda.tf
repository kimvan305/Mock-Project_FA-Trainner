locals{
    lambda_zip_location="apigateway_lambda.zip"
    kinesis_lambda_zip_location="event_kinesis_lambda.zip"
}
data "archive_file" "apigateway_lambda" {
  type        = "zip"
  source_file = "src/apigateway_lambda.py"
  output_path = "${local.lambda_zip_location}"
}
data "archive_file" "kinesis_lambda" {
  type        = "zip"
  source_file = "src/event_kinesis_lambda.py"
  output_path = "${local.kinesis_lambda_zip_location}"
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
resource "aws_lambda_function" "kinesis_firehose_data_transformation_lambda" {
  filename      = "${local.kinesis_lambda_zip_location}"#"${local.lambda_zip_location}"
  function_name = "event_kinesis_lambda"
  role          = aws_iam_role.apigateway_lambda_role.arn
  handler       = "event_kinesis_lambda.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #source_code_hash = "${base64sha256(file("${local.lambda_zip_location}"))}"
  #source_code_hash = filebase64sha256("${local.lambda_zip_location}")
  source_code_hash = data.archive_file.kinesis_lambda.output_base64sha256
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
  policy = jsonencode(
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
    },
    {
    "Effect": "Allow",
    "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListStreams",
        "kinesis:PutRecords"
    ],
    "Resource": [
      "arn:aws:kinesis:::${aws_kinesis_stream.api_stream.arn}",
      "arn:aws:kinesis:::${aws_kinesis_stream.api_stream.arn}/*"
    ]
    }
  ]
}
)
}

    # {
    #   "Sid": "",
    #   "Resource": "*",
    #   "Action": [
    #     "logs:CreateLogGroup",
    #     "logs:CreateLogStream",
    #     "logs:PutLogEvents"
    #   ],
    #   "Effect": "Allow"
    # },
resource "aws_iam_role_policy_attachment" "apigw_lambda_policy" {
  role       = aws_iam_role.apigateway_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_kinesis_execution" {
  role = "${aws_iam_role.apigateway_lambda_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apigateway_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.mydemo_api.execution_arn}/*/*/*"
}



resource "aws_lambda_event_source_mapping" "kinesis_lambda_mapping" {
  event_source_arn  = aws_kinesis_stream.api_stream.arn
  function_name     = aws_lambda_function.kinesis_firehose_data_transformation_lambda.arn
  starting_position = "LATEST"
}