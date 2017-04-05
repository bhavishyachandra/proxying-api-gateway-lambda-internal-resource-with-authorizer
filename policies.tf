data "aws_iam_policy_document" "proxy_lambda_role" {

  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "proxy_lambda_role" {

  name = "proxy_lambda_role"
  assume_role_policy = "${data.aws_iam_policy_document.proxy_lambda_role.json}"
}

data "aws_iam_policy_document" "api_gateway_lambda_invocation_role" {

  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_vpc_access" {
  role = "${aws_iam_role.proxy_lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role" "api_gateway_execute_authorizer" {

  name = "api_gateway_execute_authorizer"
  assume_role_policy = "${data.aws_iam_policy_document.api_gateway_lambda_invocation_role.json}"
}

data "aws_iam_policy_document" "api_gateway_authorizer_invocation" {

  statement {

    actions = [ "lambda:InvokeFunction" ]
    resources = [ "${aws_lambda_function.authorizer_lambda.arn}" ]
  }
}

resource "aws_iam_role_policy" "api_gateway_authorizer_invocation" {
  name = "default"
  role = "${aws_iam_role.api_gateway_execute_authorizer.id}"

  policy = "${data.aws_iam_policy_document.api_gateway_authorizer_invocation.json}"
}
