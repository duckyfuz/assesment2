data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../lambda_src/lambda.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "assignment2_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "gcc_assignment2_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.11"
}

resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.assignment2_lambda.function_name
  authorization_type = "NONE"
}

output "lambda_url" {
  value = aws_lambda_function_url.lambda_url.function_url
}