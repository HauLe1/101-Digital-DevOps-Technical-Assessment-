resource "aws_iam_role" "lambda_exec" {
  name = "${var.name}-lambda-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}
resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_lambda_function" "authorizer" {
  filename         = var.zip_file_path
  function_name    = "${var.name}-authorizer"
  role             = aws_iam_role.lambda_exec.arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.zip_file_path)
  environment {
    variables = var.environment
  }
resource "aws_apigatewayv2_authorizer" "lambda_auth" {
  api_id = aws_apigatewayv2_api.http_api.id
  name   = "lambda-authorizer"
  authorizer_type = "REQUEST"
  authorizer_uri  = aws_lambda_function.authorizer.invoke_arn
  identity_sources = ["$request.header.Authorization"]
}
}