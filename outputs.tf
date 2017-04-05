output "api_gateway_endpoint" {
  value = "https://${aws_api_gateway_deployment.proxy_api_poc_deployment.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.proxy_api_poc_deployment.stage_name}"
}