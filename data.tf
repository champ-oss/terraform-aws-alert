data "archive_file" "lambda_zip" {
  count            = var.enabled ? 1 : 0
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/cloudwatch_slack.py"
  output_path      = "${path.module}/cloudwatch_slack.zip"
}

moved {
  from = data.archive_file.lambda_zip
  to   = data.archive_file.lambda_zip[0]
}
