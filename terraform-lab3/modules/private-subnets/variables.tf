variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "nat_gateway_id" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}
