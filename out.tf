output "certificate_arn" {
    value = aws_acm_certificate_validation.lb_dns_validation.certificate_arn
}

output "dns_name" {
    value = aws_route53_record.dns_record.name
}