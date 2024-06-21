terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "Strapi_Instance_sg" {
  name = "Strapi_sg12"
  description = "Allow HTTP, HTTPS, and Strapi ports"

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Strapi"
    from_port = 1337
    to_port = 1337
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "Strapi_Instance" {
  ami = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  count = 1
  tags = {
    Name = "Strapi_Instance_Task-3"
  }


key_name = "my_strapi_task-2_key"

user_data = <<-EOF
                !/bin/bash
                sudo apt update -y
                sudo apt install -y nodejs npm git
                sudo npm install -g pm2
                sudo mkdir -p /srv/strapi
                cd /srv/strapi
                git clone https://github.com/strapi/strapi.git /srv/strapi
                sudo npm install
                pm2 start npm --name "strapi" -- start
                EOF

}

output "Strapi_Instance_IP"{
  value = aws_instance.Strapi_Instance.public_ip
}