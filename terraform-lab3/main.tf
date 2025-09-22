module "vpc" {
  source      = "./modules/vpc"
  name_prefix = var.name_prefix
  vpc_cidr    = var.vpc_cidr
}

module "public_subnets" {
  source              = "./modules/public-subnets"
  name_prefix         = var.name_prefix
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "private_subnets" {
  source               = "./modules/private-subnets"
  name_prefix          = var.name_prefix
  vpc_id               = module.vpc.vpc_id
  private_subnet_cidrs = var.private_subnet_cidrs
  nat_gateway_id       = module.public_subnets.nat_gateway_id
  availability_zones   = var.availability_zones
}



module "security" {
  source      = "./modules/security"
  name_prefix = var.name_prefix
  vpc_id      = module.vpc.vpc_id
  my_ip       = var.my_ip
}



module "public_alb" {
  source            = "./modules/loadbalancer"
  name_prefix       = "${var.name_prefix}-public"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.public_subnets.public_subnet_ids
  security_group_id = module.security.public_alb_sg
  internal          = false
  target_ids        = module.ec2.public_instance_ids # Public ALB → Public EC2s
}

module "private_alb" {
  source            = "./modules/loadbalancer"
  name_prefix       = "${var.name_prefix}-private"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.private_subnets.private_subnet_ids
  security_group_id = module.security.private_alb_sg
  internal          = true
  target_ids        = module.ec2.private_instance_ids # Private ALB → Private EC2s
}

module "ec2" {
  source             = "./modules/ec2"
  name_prefix        = var.name_prefix
  public_subnet_ids  = module.public_subnets.public_subnet_ids
  private_subnet_ids = module.private_subnets.private_subnet_ids
  instance_type      = var.instance_type
  key_name           = var.key_name

  public_sg_id    = module.security.public_ec2_sg
  private_sg_id   = module.security.private_ec2_sg
  private_alb_dns = module.private_alb.alb_dns
}
