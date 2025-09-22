variable "name_prefix" {
  type = string
}

variable "subnet_ids" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "target_ids" {
  description = "List of instance IDs to register in the target group"
  type        = list(string)
  default     = []
}

variable "internal" {
  description = "Whether the ALB is internal (true) or internet-facing (false)"
  type        = bool
  default     = false
}
