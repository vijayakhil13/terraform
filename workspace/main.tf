provider "aws" {
    region = "us-east-1"
}
variable "ami" {
    default= "ami-020cba7c55df1f615" # Example AMI ID, replace with your desired AMI
  
}
variable "instance_type" {
    type= map(string)
    default={
        dev="t2.micro"
        stage="t2.small"
        prod="t2.medium"
    }
    }
  

resource "aws_instance" "name" {
    ami = var.ami
    instance_type = lookup(var.instance_type,terraform.workspace,"t2.micro")
}