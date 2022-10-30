# create a VPC/Network where we want to deploy our resources
resource "aws_vpc" "Nginx-Vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = "true"
    instance_tenancy     = "default"

    tags = {
        Name = "Nginx_VPC"
    }
}

# Create single public subnet
resource "aws_subnet" "Nginx-PubSub" {
    vpc_id                  = aws_vpc.Nginx-Vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = "true"

    tags = {
        Name = "Nginx_PubSub"
    }
}

# create an Internet Gateway for above VPC
resource "aws_internet_gateway" "Nginx-IGW" {
    vpc_id = aws_vpc.Nginx-Vpc.id

    tags = {
       Name = "Nginx_IGW"
    }
}

# create route table for VPC
resource "aws_route_table" "Nginx-PubSub-RT" {
    vpc_id = aws_vpc.Nginx-Vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Nginx-IGW.id

    }
    
    tags = {
       Name = "Nginx_PubSubRT"
    }
}

# associate the route table to our pub subnet
resource "aws_route_table_association" "Nginx-RTA-PubSub" {
    subnet_id = aws_subnet.Nginx-PubSub.id
    route_table_id = aws_route_table.Nginx-PubSub-RT.id
}