variable "ami" {
    description = "The AMI ID to use for the instance"
    type        = string
}

variable "instance_type" {
    description = "The type of instance to launch"
    type        = string
}
variable "subnet_id" {
    description = "The subnet ID to launch the instance in"
    type        = string
}
variable "key_name" {
  description = "value of the key pair to use for SSH access"
  type = string
}
variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate"
  type        = list(string)
}