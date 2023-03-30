locals {
  route_details = split("_",var.route_details)
}
resource "aws_route" "aws_route" {
  route_table_id = local.route_details[0]
  gateway_id = local.route_details[1]
  destination_cidr_block = var.destination_cidr_block
}
