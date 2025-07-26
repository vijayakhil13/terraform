provider "aws" {
    region = "us-east-1"  
}
variable "vpc_cidr" {
    default ="10.0.0.0/16"  
}
resource aws_key_pair "name"{
    key_name="vineeth_terraform" # Name of the key pair
    public_key=file("~/.ssh/id_rsa.pub") # Path to your public key
 
    }
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
}
resource "aws_subnet" "name" {
 vpc_id=aws_vpc.vpc.id 
 cidr_block="10.0.0.0/24"
 availability_zone = "us-east-1a"
 map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "name" {
    vpc_id=aws_vpc.vpc.id
}
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id=aws_internet_gateway.name.id
}
}
resource "aws_route_table_association" "name" {
route_table_id = aws_route_table.name.id 
subnet_id = aws_subnet.name.id
} 

resource "aws_security_group" "name" {
vpc_id = aws_vpc.vpc.id
ingress{
    from_port=22
    to_port=22
    protocol="tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
ingress{
    from_port = 80
    to_port = 80
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
resource "aws_instance" "ec2" {
    ami= "ami-020cba7c55df1f615" # Example AMI ID, replace with your own
    instance_type = "t2.micro" # Example instance type, replace with your own
    vpc_security_group_ids = [aws_security_group.name.id]
    subnet_id= aws_subnet.name.id
    key_name=aws_key_pair.name.key_name
    connection{
        type="ssh"
        user = "ubuntu" # Default user for Ubuntu AMIs
        private_key = file("~/.ssh/id_rsa") # Path to your private
        host = self.public_ip
    }  
    provisioner "file" {
        source="app.py"
        destination = "/home/ubuntu/app.py"
      
    }
    provisioner "remote-exec"{
        inline=[
            "sudo apt update -y ",
            "sudo apt-get install -y python3-pip",
            "cd /home/ubuntu",
            "sudo pip3 install flask",
            "sudo python3 app.py &", # Run the app in the background
        ]

    }
}
