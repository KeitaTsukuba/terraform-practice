resource "aws_cloudwatch_log_group" "for_ecs" {
  name              = "/ecs/example"
  retention_in_days = 180
}

resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
  name              = "/ecs-scheduled-tasks/example"
  retention_in_days = 180
}

resource "aws_cloudwatch_event_rule" "example_batch" {
  name                = "example-batch"
  description         = "とても重要なバッチ処理です"
  schedule_expression = "cron(*/2 * * * ? *)"
}

data "aws_iam_role" "ecs-events" {
  name = "ecs-events"
}

data "aws_ecs_cluster" "example" {
  cluster_name = "example"
}

data "aws_ecs_task_definition" "example_batch" {
  task_definition = "example-batch"
}

data "aws_subnet" "private_0" {
    cidr_block = "10.0.65.0/24"
}

resource "aws_cloudwatch_event_target" "example_batch" {
  target_id = "example-batch"
  rule      = aws_cloudwatch_event_rule.example_batch.name
  role_arn  = data.aws_iam_role.ecs-events.arn
  arn       = data.aws_ecs_cluster.example.arn

  ecs_target {
    launch_type         = "FARGATE"
    task_count          = 1
    platform_version    = "1.3.0"
    task_definition_arn = data.aws_ecs_task_definition.example_batch.arn

    network_configuration {
      assign_public_ip = "false"
      subnets          = [data.aws_subnet.private_0.id]
    }
  }
}