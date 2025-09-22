output "public_instance_ids" {
  description = "IDs of public EC2 instances"
  value       = aws_instance.public[*].id
}

output "public_ips" {
  description = "Public IPs of public EC2 instances"
  value       = aws_instance.public[*].public_ip
}

output "private_instance_ids" {
  description = "IDs of private EC2 instances"
  value       = aws_instance.private[*].id
}

output "private_ips" {
  description = "Private IPs of private EC2 instances"
  value       = aws_instance.private[*].private_ip
}
