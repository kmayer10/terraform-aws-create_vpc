output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_ids" {
  value = [
    for id in module.createPublicSubnet: id.id
  ]
}
output "private_subnet_ids" {
  value = [
    for id in module.createPrivateSubnet: id.id
  ]
}
