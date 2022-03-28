output "function_name" {
  description = "Name of the Lambda function."

  #value = aws_lambda_function.apigateway_lambda.function_name
  value = aws_lambda_function.apigateway_lambda.arn 
}
output "s3_bucket" {
  description = "Name of s3."

  #value = aws_lambda_function.apigateway_lambda.function_name
  value = aws_dynamodb_table.count_row_csv.arn
}
output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_api_gateway_stage.dev_stage.invoke_url
}