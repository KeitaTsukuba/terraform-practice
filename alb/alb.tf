data "aws_security_group" "http_redirect_sg" {
    name = "http-redirect-sg"
} 

data "aws_security_group" "http_sg" {
    name = "http-sg"
}

data "aws_security_group" "https_sg" {
    name = "https-sg"
}

data "aws_subnet" "public_0" {
    cidr_block = "10.0.1.0/24"
}

data "aws_subnet" "public_1" {
    cidr_block = "10.0.2.0/24"
}

data "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-keitaaa-terraform"
}

resource "aws_lb" "example" {
  name                       = "example"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  # albを削除できるように設定
  enable_deletion_protection = false

  subnets = [
    data.aws_subnet.public_0.id,
    data.aws_subnet.public_1.id,
  ]

  access_logs {
    bucket  = data.aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    data.aws_security_group.http_sg.id,
    data.aws_security_group.https_sg.id,
    data.aws_security_group.http_redirect_sg.id,
  ]
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
}
