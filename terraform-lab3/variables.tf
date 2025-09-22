variable "region" {
  default = "us-east-1"
}

variable "name_prefix" {
  default = "lab3"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}


variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 KeyPair to enable SSH access"
  type        = string
  default     = "my-kay-1"
}

variable "my_ip" {
  description = "Your public IP for SSH access (use CIDR format)"
  type        = string
  default     = "0.0.0.0/0"

}