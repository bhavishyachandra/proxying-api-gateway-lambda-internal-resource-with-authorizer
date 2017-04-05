resource "aws_api_gateway_rest_api" "proxy_api" {
  name = "proxy_api"
}

resource "aws_api_gateway_method" "root_proxy_resource_method" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  resource_id = "${aws_api_gateway_rest_api.proxy_api.root_resource_id}"
  http_method = "ANY"
  authorizer_id = "${var.enable_authorizer == true ? aws_api_gateway_authorizer.do_nothing_authorizer.id : ""}"
  authorization = "${var.enable_authorizer == true ? "CUSTOM" : "NONE"}"
}

resource "aws_api_gateway_integration" "root_proxy_resource_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  resource_id = "${aws_api_gateway_rest_api.proxy_api.root_resource_id}"
  http_method = "${aws_api_gateway_method.root_proxy_resource_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.proxy_lambda.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  parent_id = "${aws_api_gateway_rest_api.proxy_api.root_resource_id}"
  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_resource_method" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  resource_id = "${aws_api_gateway_resource.proxy_resource.id}"
  http_method = "ANY"
  authorizer_id = "${var.enable_authorizer == true ? aws_api_gateway_authorizer.do_nothing_authorizer.id : ""}"
  authorization = "${var.enable_authorizer == true ? "CUSTOM" : "NONE"}"
}

resource "aws_api_gateway_integration" "proxy_resource_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  resource_id = "${aws_api_gateway_resource.proxy_resource.id}"
  http_method = "${aws_api_gateway_method.proxy_resource_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.proxy_lambda.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "proxy_api_poc_deployment" {

  depends_on = ["aws_api_gateway_integration.root_proxy_resource_integration", "aws_api_gateway_integration.proxy_resource_integration"]

  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  stage_name = "internal_proxy_poc"
  stage_description = "A deployment of the API which proxies all non-binary requests and responses to a webserver backend."
}

resource "aws_api_gateway_authorizer" "do_nothing_authorizer" {
  name = "do_nothing_authorizer"
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  authorizer_uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.authorizer_lambda.arn}/invocations"
  authorizer_credentials = "${aws_iam_role.api_gateway_execute_authorizer.arn}"
  authorizer_result_ttl_in_seconds = 900
}
