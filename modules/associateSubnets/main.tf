resource "aws_route_table_association" "privateSubnets" {
  route_table_id = var.route_table_id
  subnet_id      = var.subnet_id
}
