data "aws_route53_zone" "example" {
  name = "museum-app.com"
}

data "aws_lb" "example" {
  name = "example"
}

resource "aws_route53_record" "example" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = data.aws_route53_zone.example.name
  type    = "A"

  alias {
    name                   = data.aws_lb.example.dns_name
    zone_id                = data.aws_lb.example.zone_id
    evaluate_target_health = true
  }
}

output "domain_name" {
  value = aws_route53_record.example.name
}