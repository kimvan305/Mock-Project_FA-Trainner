locals{
    lambda_zip_location="lambda-count.zip"
}
data "archive_file" "lambda-count" {
  type        = "zip"
  source_file = "src/lambda.py"
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "lambda-count" {
  filename      = "${local.lambda_zip_location}"
  function_name = "lambda-count"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "src/lambda.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #source_code_hash = "${base64sha256(file("${local.lambda_zip_location}"))}"
  #source_code_hash = filebase64sha256("${local.lambda_zip_location}")
  source_code_hash = data.archive_file.lambda-count.output_base64sha256

  runtime = "python3.7"


}