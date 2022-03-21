locals{
    lambda_zip_location="count-row-csv-lambda.zip"
}
data "archive_file" "count-row-csv-lambda" {
  type        = "zip"
  source_file = "../src/count-row-csv-lambda.py"
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "count-row-csv-lambda" {
  filename      = "count-row-csv-lambda.zip"#"${local.lambda_zip_location}"
  function_name = "count-row-csv-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "count-row-csv-lambda.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #source_code_hash = "${base64sha256(file("${local.lambda_zip_location}"))}"
  #source_code_hash = filebase64sha256("${local.lambda_zip_location}")
  source_code_hash = data.archive_file.count-row-csv-lambda.output_base64sha256
  timeout = 120
  runtime = "python3.7"


}