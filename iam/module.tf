module "describe_regions_for_ec2" {
  source     = "./iam-main"
  name       = "describe-regions-for-ec2"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.allow_describe_regions.json
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions"] # リージョン一覧を取得する
    resources = ["*"]
  }
}

######## for ecs ########

data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

module "ecs_task_execution_role" {
  source     = "./iam-main"
  name       = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}

data "aws_iam_policy" "ecs_events_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

module "ecs_events_role" {
  source     = "./iam-main"
  name       = "ecs-events"
  identifier = "events.amazonaws.com"
  policy     = data.aws_iam_policy.ecs_events_role_policy.policy
}
