resource "aws_security_group" "this" {
  name        = "${var.workspace_name}-sg"
  description = var.sec_group_desc
  vpc_id      = data.aws_vpc.selected.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.workspace_name}-security-group",
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each                     = var.ingress_rule != null ? { for rule in var.ingress_rule : rule.description => rule } : {}
  description                  = each.value.description
  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = each.value.cidr_ipv4
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each                     = var.egress_rule != null ? { for rule in var.egress_rule : rule.description => rule } : {}
  description                  = each.value.description
  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = each.value.cidr_ipv4
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  referenced_security_group_id = each.value.referenced_security_group_id
}