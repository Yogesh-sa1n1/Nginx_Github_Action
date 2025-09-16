provider "aws"{
    region= "us-east-1"

}

resource "aws_security_group" "securityGroup"{
    name= "Github Action"
    description= "allow ssh access and tcp 8080"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol ="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "tls_private_key" "KeyPair"{
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "githubAction"
  public_key = tls_private_key.KeyPair.public_key_openssh
}

# resource "local_file" "pemFile" {
#   content         = tls_private_key.KeyPair.private_key_pem
#   filename        = "${path.module}/githubAction.pem"
# }

resource "aws_instance" "ec2_instance" {
    ami = "ami-0360c520857e3138f"
    instance_type = "t2.micro"
    key_name =aws_key_pair.generated_key.key_name
    vpc_security_group_ids = [aws_security_group.securityGroup.id]
    user_data = base64encode(templatefile("${path.module}/user_data.sh.tmpl",{}))
    tags = {
        Name ="GitHubAction"
        Team = "Dev"
}
}





