provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_task_definition" "test" {
  family                   = var.task_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  execution_role_arn      = "arn:aws:iam::508563857051:role/ecsTaskExecutionRole"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.container_arn
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_lb" "main" {
  name               = "test-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.subnets
}

resource "aws_lb_target_group" "test" {
  name        = "test-target-group"
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

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}


resource "aws_ecs_service" "main" {
  name            = var.task_name
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.test.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.ecs_sg]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.test.arn
    container_name   = var.container_name
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.test]
}
