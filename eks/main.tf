provider "aws" {
    region = "us-east-1"
}
data "aws_availability_zones" "available" {
    state = "available"
}
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    count=2
    cidr_block = cidrsubnet(aws_vpc.name.cidr_block,8,count.index)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
}
resource "aws_route_table" "name" {
vpc_id = aws_vpc.name.id
route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
}
}
resource "aws_route_table_association" "name" {
    count=2
    subnet_id=element(aws_subnet.name.*.id,count.index)
    route_table_id = aws_route_table.name.id
}
resource "aws_iam_role" "name" {
    name="eks-cluster-role"
    assume_role_policy = jsonencode({
        Version= "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "eks.amazonaws.com"
                }
            },{
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "ec2.amazonaws.com"  # Added for EC2
                }
            }
        ]       
    })  
}

resource "aws_iam_role_policy_attachment" "name" {
    role=aws_iam_role.name.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  
}
resource "aws_eks_cluster" "name" {
    name = "eks-cluster"
    role_arn = aws_iam_role.name.arn
    vpc_config {
      subnet_ids=aws_subnet.name[*].id
    }  
}
resource "aws_eks_node_group" "name"{
    cluster_name = aws_eks_cluster.name.name
    node_group_name = "eks-node-group"
    node_role_arn = aws_iam_role.name.arn
    subnet_ids = aws_subnet.name.*.id
    scaling_config{
        desired_size=1
        max_size=1
        min_size=1
    }
    instance_types = ["t2.micro"]
}

