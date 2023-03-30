output "id" {
  value = [
    for subnet in aws_subnet.aws_subnet : subnet.id
  ]
}
