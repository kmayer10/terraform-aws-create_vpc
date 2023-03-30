resource "aws_subnet" "aws_subnet" {
  count             = local.count
  vpc_id            = var.vpc_id
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[count.index]
  #cidr_block = "${element(var.cidr_block, count.index)}"
  cidr_block = "${local.cidr[0]}.${local.cidr[1]}.${var.subnet_cidr_start_number + count.index}.0/24"
  tags = {
    Name = "${var.Name}_${var.Type}_${var.subnet_cidr_start_number + count.index}"
    Type = var.Type
  }
  map_public_ip_on_launch = var.Type == "Private" ? false : true
}
