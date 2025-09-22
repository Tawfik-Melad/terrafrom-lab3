variable "name_prefix" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "public_sg_id" {
  description = "Security group ID for public EC2 instances"
  type        = string
}

variable "private_sg_id" {
  description = "Security group ID for private EC2 instances"
  type        = string
}

variable "private_alb_dns" {
  description = "DNS of the private ALB (for proxy config on public EC2s)"
  type        = string
}

