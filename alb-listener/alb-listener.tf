data "aws_lb" "example" {
  name = "example"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = data.aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTP』です"
      status_code  = "200"
    }
  }
}

data "aws_route53_zone" "example" {
  name = "museum-app.com"
}

data "aws_acm_certificate" "example" {
  domain   = data.aws_route53_zone.example.name
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = data.aws_lb.example.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.example.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "これは『HTTPS』です"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = data.aws_lb.example.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

data "aws_lb_target_group" "example" {
  name = "example"
}

resource "aws_lb_listener_rule" "example" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.example.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}