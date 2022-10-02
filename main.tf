provider "aws" {
  region     = var.region
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.fqdn
  validation_method = "DNS"

  tags = var.cert_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_record" {
    zone_id = var.domain_zone_id
    name = var.fqdn
    type = "A"
    alias {
        name = var.load_balancer_name
        zone_id = var.load_balancer_zone_id
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "lb_dns_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.domain_zone_id
}

resource "aws_acm_certificate_validation" "lb_dns_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.lb_dns_record : record.fqdn]
}