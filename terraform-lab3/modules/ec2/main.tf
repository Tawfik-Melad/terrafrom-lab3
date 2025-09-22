data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu official account)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "public" {
  count                       = length(var.public_subnet_ids)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_ids[count.index]
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx

              # Configure Nginx as reverse proxy to private ALB
              cat > /etc/nginx/sites-available/default <<EOL
              server {



                listen 80;
                server_name _;

                  location /health {
                    return 200 "ok";
                  }

                location / {
                  proxy_pass http://${var.private_alb_dns};
                  proxy_set_header Host \$host;
                  proxy_set_header X-Real-IP \$remote_addr;
                  proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                }
              }
              EOL

              systemctl restart nginx
              EOF


  tags = { Name = "${var.name_prefix}-public-${count.index}" }
}

resource "aws_instance" "private" {
  count                       = length(var.private_subnet_ids)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.private_subnet_ids[count.index]
  vpc_security_group_ids      = [var.private_sg_id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "Hello from PRIVATE $(hostname)" > /var/www/html/index.html

              # Configure Nginx as reverse proxy to private ALB
              cat > /etc/nginx/sites-available/default <<EOL
              server {
                listen 80;
                server_name _;

                  location /health {
                    return 200 "ok";
                  }
              }
              EOL

              EOF

  tags = { Name = "${var.name_prefix}-private-${count.index}" }
}
