resource "aws_cloudwatch_log_group" "app" {
  name              = "/eks/max-weather/app"
  retention_in_days = var.retention_in_days
  tags = var.tags
}
resource "aws_iam_role" "fluentbit" {
  name = "${var.name}-fluentbit-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs.json
}