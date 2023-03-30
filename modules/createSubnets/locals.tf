data "aws_availability_zones" "aws_availability_zones" {
  state = "available"
}
data "aws_vpc" "aws_vpc" {
  id = var.vpc_id
}
locals {
  count = length(data.aws_availability_zones.aws_availability_zones.names)
  cidr  = split(".", data.aws_vpc.aws_vpc.cidr_block)
}
