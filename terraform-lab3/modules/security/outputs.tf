output "public_ec2_sg" {
  value = aws_security_group.public_ec2.id
}

output "private_ec2_sg" {
  value = aws_security_group.private_ec2.id
}

output "public_alb_sg" {
  value = aws_security_group.public_alb.id
}

output "private_alb_sg" {
  value = aws_security_group.private_alb.id
}
