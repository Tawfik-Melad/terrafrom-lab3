# SG for public EC2s
resource "aws_security_group" "public_ec2" {
  name        = "${var.name_prefix}-public-ec2-sg"
  description = "Allow SSH + HTTP from internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-public-ec2-sg" }
}

# SG for private EC2s
resource "aws_security_group" "private_ec2" {
  name        = "${var.name_prefix}-private-ec2-sg"
  description = "Allow HTTP from private LB only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from Private ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.private_alb.id]
  }


  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-private-ec2-sg" }
}

# SG for public ALB
resource "aws_security_group" "public_alb" {
  name        = "${var.name_prefix}-public-alb-sg"
  description = "Allow HTTP from internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-public-alb-sg" }
}

# SG for private ALB
resource "aws_security_group" "private_alb" {
  name        = "${var.name_prefix}-private-alb-sg"
  description = "Allow HTTP from public ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from public ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}-private-alb-sg" }
}
