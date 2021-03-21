resource "aws_api_gateway_rest_api" "apis" {
  name = "apis"
}

# resource /projects
resource "aws_api_gateway_resource" "get_projects_res" {
  path_part   = "projects"
  parent_id   = "${aws_api_gateway_rest_api.apis.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.apis.id}"
}

# method GET /projects
resource "aws_api_gateway_method" "get_projects_met" {
  rest_api_id   = "${aws_api_gateway_rest_api.apis.id}"
  resource_id   = "${aws_api_gateway_resource.get_projects_res.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "project_endpoint_1" {
  rest_api_id             = "${aws_api_gateway_rest_api.apis.id}"
  resource_id             = "${aws_api_gateway_resource.get_projects_res.id}"
  http_method             = "${aws_api_gateway_method.get_projects_met.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.apiProjects.invoke_arn}"
}

# resource /projects/{id}
resource "aws_api_gateway_resource" "get_projects_id_res" {
  path_part   = "{id}"
  parent_id   = "${aws_api_gateway_resource.get_projects_res.id}"
  rest_api_id = "${aws_api_gateway_rest_api.apis.id}"
}

# resource /projects/{id}/comments
resource "aws_api_gateway_resource" "get_projects_id_comments_res" {
  path_part   = "comments"
  parent_id   = "${aws_api_gateway_resource.get_projects_id_res.id}"
  rest_api_id = "${aws_api_gateway_rest_api.apis.id}"
}

# method GET /projects/{id}/comments
resource "aws_api_gateway_method" "get_projects_id_comments_met" {
  rest_api_id   = "${aws_api_gateway_rest_api.apis.id}"
  resource_id   = "${aws_api_gateway_resource.get_projects_id_comments_res.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "project_endpoint_2" {
  rest_api_id             = "${aws_api_gateway_rest_api.apis.id}"
  resource_id             = "${aws_api_gateway_resource.get_projects_id_comments_res.id}"
  http_method             = "${aws_api_gateway_method.get_projects_id_comments_met.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.apiProjects.invoke_arn}"
}

# resource /issues
resource "aws_api_gateway_resource" "get_issues_res" {
  path_part   = "issues"
  parent_id   = "${aws_api_gateway_rest_api.apis.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.apis.id}"
}

# method GET /issues
resource "aws_api_gateway_method" "get_issues_met" {
  rest_api_id   = "${aws_api_gateway_rest_api.apis.id}"
  resource_id   = "${aws_api_gateway_resource.get_issues_res.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "issues_endpoint_1" {
  rest_api_id             = "${aws_api_gateway_rest_api.apis.id}"
  resource_id             = "${aws_api_gateway_resource.get_issues_res.id}"
  http_method             = "${aws_api_gateway_method.get_issues_met.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.apiIssues.invoke_arn}"
}

# resource /comments
resource "aws_api_gateway_resource" "get_comments_res" {
  path_part   = "comments"
  parent_id   = "${aws_api_gateway_rest_api.apis.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.apis.id}"
}

# method GET /comments
resource "aws_api_gateway_method" "get_comments_met" {
  rest_api_id   = "${aws_api_gateway_rest_api.apis.id}"
  resource_id   = "${aws_api_gateway_resource.get_comments_res.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "comments_endpoint_1" {
  rest_api_id             = "${aws_api_gateway_rest_api.apis.id}"
  resource_id             = "${aws_api_gateway_resource.get_comments_res.id}"
  http_method             = "${aws_api_gateway_method.get_comments_met.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.apiComments.invoke_arn}"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    "aws_api_gateway_integration.project_endpoint_1",
    "aws_api_gateway_integration.project_endpoint_2",
    "aws_api_gateway_integration.issues_endpoint_1",
    "aws_api_gateway_integration.comments_endpoint_1",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.apis.id}"
  stage_name  = "stage1"
}

resource "aws_lambda_permission" "api_gateway_apiProjects_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.apiProjects.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apis.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_apiIssues_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.apiIssues.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apis.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_apiComments_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.apiComments.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.apis.execution_arn}/*/*"
}