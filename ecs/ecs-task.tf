resource "aws_ecs_task_definition" "example" {
  family                   = "example"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution"
}

resource "aws_ecs_task_definition" "example2" {
  family                   = "example"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
}

# ecs-batch task
# resource "aws_ecs_task_definition" "example_batch" {
#   family                   = "example-batch"
#   cpu                      = "256"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   container_definitions    = file("./batch_container_definitions.json")
#   execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
# }