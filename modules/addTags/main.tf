resource "aws_ec2_tag" "defaultRouteTable" {
  resource_id = var.resource_id
  key         = var.key
  value       = var.value
}
