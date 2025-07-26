provider "aws" {
    region = "us-east-1"
}
resource "vpc_id" "example" {
    vpc_id=var.vpc_id
    cidr_block = ["172.31.0.0/16"]
  
}
resource "aws_instance" "example" {
    ami= var.ami
    instance_type=var.instance_type
    subnet_id=var.subnet_id
    key_name=var.key_name
    vpc_security_group_ids = ["sg-0fa66613e5b18d374"]

    //ssh_username = "ec2-user"
    
}
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = vpc_id.example.vpc_id  # Replace with your VPC ID

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows SSH from anywhere. For better security, restrict to your IP.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
    value = aws_instance.example.public_ip
  
}