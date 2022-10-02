variable "region" {
  description = "AWS Region"
  type = string
}

variable "fqdn" {
  description = "Fully qualified domain name"
  type = string
}

variable "cert_tags" {
    type = map(string)
    default = null
}

variable "domain_zone_id" {
    description = "Predefined domain zone ID"
    type = string
}

variable "load_balancer_name" {
    description = "Name of the Load Balancer"
    type = string
}

variable "load_balancer_zone_id" {
    description = "Zone ID of the Load Balancer"
    type = string
}