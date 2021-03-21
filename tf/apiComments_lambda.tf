resource "aws_lambda_function" "apiComments" {
  function_name = "apiComments"
  s3_bucket     = "artifact-lamdas"
  s3_key        = "api-comments.zip"
  handler       = "api-comments/src/index.handler"
  runtime       = "nodejs10.x"
  role          = "${aws_iam_role.lambda_exec.arn}"
}

resource "aws_cloudwatch_log_group" "apiComments-lambda-cloudwatch-log-group" {
  name              = "/aws/lambda/apiComments"
  retention_in_days = 7
}

resource "aws_iam_role_policy" "apiComments-lambda-cloudwatch-access" {
  name = "apiComments-lambda-cloudwatch-access"
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
        "${aws_cloudwatch_log_group.apiComments-lambda-cloudwatch-log-group.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.apiComments-lambda-cloudwatch-log-group.arn}:*"
      ]
    }
  ]
}
EOF
}