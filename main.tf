resource "aws_security_group" "default" {
  for_each = var.security_groups
 
  name        = each.key
  description = each.value.description
  vpc_id      = var.vpc_id
 
  dynamic "ingress" {
    for_each = each.value.ingress_rules != null ? each.value.ingress_rules : []
 
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks != null ? ingress.value.cidr_blocks : null
      security_groups = ingress.value.security_groups != null ? ingress.value.security_groups : null
    }
  }
 
  dynamic "egress" {
    for_each = each.value.egress_rules != null ? each.value.egress_rules : []
 
 
    content {
      description     = egress.value.description
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks != null ? egress.value.cidr_blocks : null
      security_groups = egress.value.security_groups != null ? egress.value.security_groups : null
    }
  }
}
 
output "security_group_id" {
  value = { for k, v in aws_security_group.default : k => v.id }
}
variable "security_groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description     = optional(string)
      priority        = optional(number)
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
    })))
    egress_rules = optional(list(object({
      description     = optional(string)
      priority        = optional(number)
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
    })))
  }))
  default = {}
}
 
variable "vpc_id" {
  type = string
}

