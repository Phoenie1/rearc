provider "aws" {
  region = "us-east-1" # Specify your desired region
}

resource "aws_lb" "main" {
  name               = "ecs-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.subnets
}

resource "aws_lb_target_group" "main" {
  name        = "ecs-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc
  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "mkw-task-1"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  execution_role_arn      = "arn:aws:iam::508563857051:role/ecsTaskExecutionRole"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "mkw-test-2"
      image = "508563857051.dkr.ecr.us-east-1.amazonaws.com/mkw_test:test"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = "mkw-service-2"
  cluster         = "arn:aws:ecs:us-east-1:508563857051:cluster/demojunk"
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.ecs_sg]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "mkw-test-2"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http]
}
