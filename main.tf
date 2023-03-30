provider "aws" {
  region = "us-east-2"
}
locals {
  name = "${var.name}-session"
  tags = {
    Name    = local.name
    trainer = "kul"
  }
}
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags                 = local.tags
}
module "addTags" {
  for_each = {
    id_1 = aws_vpc.vpc.default_route_table_id
    id_2 = aws_vpc.vpc.default_network_acl_id
    id_3 = aws_vpc.vpc.default_security_group_id
  }
  source      = "./modules/addTags"
  resource_id = each.value
  key         = "Name"
  value       = local.name
}
module "createPublicSubnet" {
  count                    = var.public_subnet_cidr_start_number == null ? 0 : 1
  source                   = "./modules/createSubnets"
  vpc_id                   = aws_vpc.vpc.id
  subnet_cidr_start_number = var.public_subnet_cidr_start_number
  Name                     = local.name
  Type                     = "Public"
}
module "createPrivateSubnet" {
  count                    = var.private_subnet_cidr_start_number == null ? 0 : 1
  source                   = "./modules/createSubnets"
  vpc_id                   = aws_vpc.vpc.id
  subnet_cidr_start_number = var.private_subnet_cidr_start_number
  Name                     = local.name
  Type                     = "Private"
}
resource "aws_internet_gateway" "igw" {
  count  = var.createInternetGateway == false ? 0 : 1
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}
resource "aws_eip" "nat_eip" {
  count = var.createNatGateway == false ? 0 : 1
  tags  = local.tags
}
resource "aws_nat_gateway" "ngw" {
  count         = var.createNatGateway == false ? 0 : 1
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = module.createPublicSubnet[0].id[0]
  tags          = local.tags
}
resource "aws_route_table" "privateRouteTable" {
  count  = var.private_subnet_cidr_start_number == null ? 0 : 1
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.name}-private-route-table"
  }
}
module "createNgwRoute" {
  count                  = var.createNatGateway == false ? 0 : 1
  source                 = "./modules/createRoutes"
  route_details          = "${aws_route_table.privateRouteTable[0].id}_${aws_nat_gateway.ngw[0].id}"
  destination_cidr_block = "0.0.0.0/0"
}
module "createIgwRoute" {
  count                  = var.createInternetGateway == false ? 0 : 1
  source                 = "./modules/createRoutes"
  route_details          = "${aws_vpc.vpc.default_route_table_id}_${aws_internet_gateway.igw[0].id}"
  destination_cidr_block = "0.0.0.0/0"
}
data "aws_availability_zones" "zones" {
  state = "available"
}
module "associatePublicSubnets" {
  count          = var.public_subnet_cidr_start_number == null ? 0 : length(data.aws_availability_zones.zones.names)
  source         = "./modules/associateSubnets"
  route_table_id = aws_vpc.vpc.default_route_table_id
  subnet_id      = module.createPublicSubnet[0].id[count.index]
}
module "associatePrivateSubnets" {
  count          = var.private_subnet_cidr_start_number == null ? 0 : length(data.aws_availability_zones.zones.names)
  source         = "./modules/associateSubnets"
  route_table_id = aws_route_table.privateRouteTable[0].id
  subnet_id      = module.createPrivateSubnet[0].id[count.index]
}
