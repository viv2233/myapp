provider "aws" {
  region = "us-east-1" # Update to your desired region
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_key_pair" "my_key" {
  key_name   = "terraform-key"                   # Name of the key pair you want to create
  public_key = file("/home/vivek/terrafrom.pem") # Path to your public key file
}

resource "aws_instance" "my_ec2" {
  ami             = "ami-084568db4383264d4" # Replace with a valid AMI ID for your region
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.allow_ssh.name]
  user_data       = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3 python3-pip
              EOF
  tags = {

    Name = "MyEC2Instance"
  }
