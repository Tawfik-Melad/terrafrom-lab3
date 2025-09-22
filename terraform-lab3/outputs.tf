output "public_alb_dns" {
  value = module.public_alb.alb_dns
}

output "private_alb_dns" {
  value = module.private_alb.alb_dns
}
