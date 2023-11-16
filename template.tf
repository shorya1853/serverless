provider "aws" {
    region = "ap-south-1"
    profile = "boto_usr"
}

data "aws_iam_role" "role" {
  name = "lambda_tf_role"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowexampleInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:893711537471:${aws_api_gateway_rest_api.example.id}/*/${aws_api_gateway_method.example.http_method}${aws_api_gateway_resource.example.path}"
}


resource "aws_lambda_function" "lambda" {
    function_name = var.function_name
    role = data.aws_iam_role.role.arn
    layers = [  ]
    runtime = "python3.10"
    handler ="main.main"
    filename = "main.zip"
    environment {
        variables = {
            "Name" = "${data.aws_iam_role.role.arn}"
        }
    }
    
}

