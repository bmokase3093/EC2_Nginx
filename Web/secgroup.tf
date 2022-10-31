# Retrieve the IP address for my Device
data "http" "My-IP" {
    url = "http://ipv4.icanhazip.com"
}

# create security group to allow port 22 for ssh and 443 to access website
resource "aws_security_group" "ssh-https" {
    vpc_id = aws_vpc.Nginx-Vpc.id
    
    ingress {
        cidr_blocks = [ "${chomp(data.http.My-IP.response_body)}/32" ]
        description = "Allow inbound Traffic on port 443"
        from_port = 443
        protocol = "tcp"
        to_port = 443
    }

    ingress {
        cidr_blocks = [ "${chomp(data.http.My-IP.response_body)}/32" ]
        description = "Allow ssh so we can configure our ec2 using provisioner"
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        protocol    = -1
    }

    tags = {
      Name = "Nginx_SG"
    }
}
