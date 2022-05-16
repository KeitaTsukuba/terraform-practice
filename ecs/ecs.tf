data "aws_vpc" "example" {
  tags = {
    Name = "example"
  }
}

data "aws_subnet" "private_0" {
    cidr_block = "10.0.65.0/24"
}

data "aws_subnet" "private_1" {
    cidr_block = "10.0.66.0/24"
}

resource "aws_ecs_cluster" "example" {
  name = "example"
}

data "aws_lb_target_group" "example" {
  name = "example"
}

resource "aws_ecs_service" "example" {
  name                              = "example"
  cluster                           = aws_ecs_cluster.example.arn
  task_definition                   = aws_ecs_task_definition.example.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.3.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_sg.security_group_id]

    subnets = [
      data.aws_subnet.private_0.id,
      data.aws_subnet.private_1.id,
    ]
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.example.arn
    container_name   = "example"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

module "nginx_sg" {
  source      = "./security_group"
  name        = "nginx-sg"
  vpc_id      = data.aws_vpc.example.id
  port        = 80
  cidr_blocks = [data.aws_vpc.example.cidr_block]
}
