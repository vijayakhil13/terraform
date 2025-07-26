provider "aws" {
  region = "us-east-1"
  
}
/*resource "aws_s3_bucket" "example" {
    bucket ="vineeth-terraform-bucket2521"
}*/
resource "aws_instance" "example" {
  ami           = "ami-020cba7c55df1f615" # Example AMI ID, replace with your own
  instance_type = "t2.micro" # Example instance type, replace with your own
  subnet_id     = "subnet-01a57b403069bcbbe" # Example subnet ID, replace with your own
  key_name      = "test" # Example key pair name, replace with your own
  vpc_security_group_ids = ["sg-0fa66613e5b18d374"] # Example security group ID, replace with your own
  
}