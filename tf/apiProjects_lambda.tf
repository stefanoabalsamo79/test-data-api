resource "aws_lambda_function" "apiProjects" {
  function_name = "apiProjects"
  s3_bucket     = "artifact-lamdas"
  s3_key        = "api-projects.zip"
  handler       = "api-projects/src/index.handler"
  runtime       = "nodejs10.x"
  role          = "${aws_iam_role.lambda_exec.arn}"

  depends_on = [
    "aws_lambda_function.apiIssues",
    "aws_lambda_function.apiComments",
  ]

  environment {
    variables = {
      API_ISSUES_LAMBDA = "${aws_lambda_function.apiIssues.function_name}",
      API_COMMENTS_LAMBDA = "${aws_lambda_function.apiComments.function_name}",
    }
  }
}

resource "aws_iam_role_policy" "apiProject_invoke_apiIssues" {
  name  = "apiProject_invoke_apiIssues"
  role  = "${aws_iam_role.lambda_exec.id}"

  depends_on = ["aws_lambda_function.apiIssues"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": "${aws_lambda_function.apiIssues.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "apiProject_invoke_apiComments" {
  name  = "apiProject_invoke_apiComments"
  role  = "${aws_iam_role.lambda_exec.id}"

  depends_on = ["aws_lambda_function.apiComments"]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": "${aws_lambda_function.apiComments.arn}"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "apiProjects-lambda-cloudwatch-log-group" {
  name              = "/aws/lambda/apiProjects"
  retention_in_days = 7
}

resource "aws_iam_role_policy" "apiProjects-lambda-cloudwatch-access" {
  name = "apiProjects-lambda-cloudwatch-access"
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
        "${aws_cloudwatch_log_group.apiProjects-lambda-cloudwatch-log-group.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.apiProjects-lambda-cloudwatch-log-group.arn}:*"
      ]
    }
  ]
}
EOF
}