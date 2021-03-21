resource "aws_lambda_function" "apiIssues" {
  function_name = "apiIssues"
  s3_bucket     = "artifact-lamdas"
  s3_key        = "api-issues.zip"
  handler       = "api-issues/src/index.handler"
  runtime       = "nodejs10.x"
  role          = "${aws_iam_role.lambda_exec.arn}"
}

resource "aws_cloudwatch_log_group" "apiIssues-lambda-cloudwatch-log-group" {
  name              = "/aws/lambda/apiIssues"
  retention_in_days = 7
}

resource "aws_iam_role_policy" "apiIssues-lambda-cloudwatch-access" {
  name = "apiIssues-lambda-cloudwatch-access"
  role = "${aws_iam_role.lambda_exec.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.apiIssues-lambda-cloudwatch-log-group.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.apiIssues-lambda-cloudwatch-log-group.arn}:*"
      ]
    }
  ]
}
EOF
}