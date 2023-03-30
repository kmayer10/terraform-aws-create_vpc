variable "name" {}
variable "cidr_block" {}
variable "public_subnet_cidr_start_number" {
  default = null
  # validation {
  #   condition     = var.public_subnet_cidr_start_number > 0 || var.public_subnet_cidr_start_number <= 255 || var.public_subnet_cidr_start_number == null
  #   error_message = "Enter the Value greater than 1 and less than or equal to 255"
  # }
}
variable "private_subnet_cidr_start_number" {
  default = null
  # validation {
  #   condition     = var.private_subnet_cidr_start_number > 0 || var.private_subnet_cidr_start_number <= 255 || var.private_subnet_cidr_start_number == null
  #   error_message = "Enter the Value greater than 1 and less than or equal to 255"
  # }
}
variable "createInternetGateway" {
  type    = bool
  default = false
}
variable "createNatGateway" {
  type    = bool
  default = false
}
