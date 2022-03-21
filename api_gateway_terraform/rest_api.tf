resource "aws_api_gateway_rest_api" "mydemo_api" {
  name        = "mydemo_api"
  description = "Lambda-powered demo API"
  depends_on = [
    aws_lambda_function.apigateway_lambda
  ]
}

resource "aws_api_gateway_resource" "mydemo_resource" {
  path_part   = "mydemo_apigw"
  parent_id   = aws_api_gateway_rest_api.mydemo_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
}

resource "aws_api_gateway_method" "apigateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.mydemo_api.id
  resource_id   = aws_api_gateway_resource.mydemo_resource.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "get_lambda_integration" {
  depends_on = [
    aws_lambda_permission.apigw_permission
  ]
  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
  resource_id = aws_api_gateway_method.apigateway_method.resource_id
  http_method = aws_api_gateway_method.apigateway_method.http_method

  integration_http_method = "POST" # https://github.com/hashicorp/terraform/issues/9271 Lambda requires POST as the integration type
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.apigateway_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [aws_api_gateway_integration.get_lambda_integration,  aws_api_gateway_method.apigateway_method]

  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
}
resource "aws_api_gateway_stage" "dev_stage" {
  stage_name = "dev"
  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
  deployment_id = aws_api_gateway_deployment.api_gateway_deployment.id
}