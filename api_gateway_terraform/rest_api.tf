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
  # api_key_required = false
  # request_parameters = {
  #   "method.request.path.proxy" = true
  # }
  # request_parameters = true
  # request_models = {
  #   "application/json" = aws_api_gateway_model.mydemo_api.name
  # }


}

resource "aws_api_gateway_integration" "get_lambda_integration" {
  depends_on = [
    aws_lambda_permission.apigw_permission, aws_lambda_function.apigateway_lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
  resource_id = aws_api_gateway_resource.mydemo_resource.id
  http_method = aws_api_gateway_method.apigateway_method.http_method

  integration_http_method = "POST" # https://github.com/hashicorp/terraform/issues/9271 Lambda requires POST as the integration type
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.apigateway_lambda.invoke_arn}"
#   request_parameters =  {
#     "integration.request.path.proxy" = "method.request.path.proxy"
#   }
#   passthrough_behavior =  "WHEN_NO_TEMPLATES"
#   request_templates = {
#     "application/json" = <<EOF
# {
#   "body" : $input.json('$'),
#   "stage" : "$context.stage"
# }
# EOF
#   }

  content_handling        = "CONVERT_TO_TEXT"

}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
  resource_id = aws_api_gateway_resource.mydemo_resource.id
  http_method = aws_api_gateway_method.apigateway_method.http_method
  status_code = "200"
}
resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
  resource_id = aws_api_gateway_resource.mydemo_resource.id
  http_method = aws_api_gateway_method.apigateway_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  content_handling        = "CONVERT_TO_TEXT"
  # response_templates = { "application/json" = "" }
  # Transforms the backend JSON response to XML
#   response_templates = {
#     "application/json" = <<EOF
# {
#   "body" : $input.json('$'),
# }
# EOF
#   }
}
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [aws_api_gateway_integration.get_lambda_integration,  aws_api_gateway_method.apigateway_method]
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.mydemo_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
}
resource "aws_api_gateway_stage" "dev_stage" {
  stage_name = "dev"
  rest_api_id = aws_api_gateway_rest_api.mydemo_api.id
  deployment_id = aws_api_gateway_deployment.api_gateway_deployment.id
}