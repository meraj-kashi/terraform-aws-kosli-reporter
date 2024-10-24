data "aws_iam_policy_document" "ecs_read_allow" {
  count = var.kosli_environment_type == "ecs" && var.create_role ? 1 : 0
  statement {
    sid    = "ECSList"
    effect = "Allow"
    actions = [
      "ecs:ListClusters",
      "ecs:ListServices",
      "ecs:ListTasks"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid = "ECSDescribe"
    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTasks",
      "ecs:DescribeClusters",
    ]
    resources = [
      "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/*",
      "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/*/*",
      "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task/*",
    ]
  }
}

data "aws_iam_policy_document" "lambda_read_allow" {
  count = var.kosli_environment_type == "lambda" && var.create_role ? 1 : 0
  statement {
    sid    = "LambdaRead"
    effect = "Allow"
    actions = [
      "lambda:GetFunctionConfiguration",
      "lambda:ListFunctions"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "s3_read_allow" {
  count = var.kosli_environment_type == "s3" && var.create_role ? 1 : 0
  statement {
    sid    = "S3Read"
    effect = "Allow"
    actions = [
      "s3:ListObjects",
      "s3:ListBucket",
      "S3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.reported_aws_resource_name}/*",
      "arn:aws:s3:::${var.reported_aws_resource_name}"
    ]
  }
}

data "aws_iam_policy_document" "ssm_read_allow" {
  count = var.create_role ? 1 : 0
  statement {
    sid    = "SSMRead"
    effect = "Allow"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.kosli_api_token_ssm_parameter_name}"
    ]
  }
}

data "aws_iam_policy_document" "combined" {
  count = var.create_role ? 1 : 0
  source_policy_documents = concat(
    data.aws_iam_policy_document.ecs_read_allow.*.json,
    data.aws_iam_policy_document.lambda_read_allow.*.json,
    data.aws_iam_policy_document.s3_read_allow.*.json,
    data.aws_iam_policy_document.ssm_read_allow.*.json
  )
}
