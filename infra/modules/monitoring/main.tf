resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.project}/${var.env}/app"
  retention_in_days = var.env == "prod" ? 30 : 7
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "/${var.project}/${var.env}/api"
  retention_in_days = var.env == "prod" ? 30 : 7
}
