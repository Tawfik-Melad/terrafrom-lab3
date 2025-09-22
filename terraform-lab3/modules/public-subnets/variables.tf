variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "igw_id" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}
