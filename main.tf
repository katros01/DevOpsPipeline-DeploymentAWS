# AWS Provider
provider "aws" {
  region = "us-east-1"

}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_lab_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach policies to EC2 role
resource "aws_iam_role_policy_attachment" "ecr_read_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# Security Group to Allow HTTP Access
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
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
}

# EC2 Instance
resource "aws_instance" "lab_server" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "main_key"

#   security_groups = [aws_security_group.allow_http.name]
#   iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "lab_server"
  }

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y docker
                systemctl start docker
                systemctl enable docker
                docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) https://376129861287.dkr.ecr.us-east-1.amazonaws.com
                docker run -d -p 80:8080 376129861287.dkr.ecr.us-east-1.amazonaws.com/my-spring-app:latest
                EOF
}

output "instance_public_ip" {
  value = aws_instance.lab_server.public_ip
}
