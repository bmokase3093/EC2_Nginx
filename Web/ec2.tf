# create the EC2 that will host Nginx server
resource "aws_instance" "nginx-webServer" {
    ami = "ami-0caef02b518350c8b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.Nginx-PubSub.id
    vpc_security_group_ids = ["${aws_security_group.ssh-https.id}"]
    key_name = aws_key_pair.Terraform_key.id

    # configure nginx using provisioner
    provisioner "file" {
        source = "nginx.sh"
        destination = "/tmp/nginx.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/nginx.sh",
            "sudo /tmp/nginx.sh"
        ]
    }

    # ssh to install nginx
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = tls_private_key.rsa.private_key_pem
    }

    tags = {
        Name = "Web_Nginx"
    }
}

# Output the public ip of our
output "Public_IP" {
    value = aws_instance.nginx-webServer.public_ip
}