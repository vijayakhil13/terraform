
    provider "aws" {
    region = "us-east-1"    
  
}
/*module "ec2" {
    source="./modules/ec2"
    ami = "ami-020cba7c55df1f615" # Example AMI ID, replace with your own
    instance_type = "t2.micro" # Example instance type, replace with your own     
    subnet_id = "subnet-01a57b403069bcbbe" # Example subnet ID, replace with your own
    key_name = "test" # Example key pair name, replace with
    vpc_security_group_ids = ["sg-0fa66613e5b18d374"] # Example security group ID, replace with your own
  
}
output "public_ip" {
    value = module.ec2.public_ip
}*/


