terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  
}
# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.0.0"
# }

provider "aws" {
  region = var.region
  shared_config_files      = ["/home/shreshth/.aws/config"]
  shared_credentials_files = ["/home/shreshth/.aws/credentials"]
  profile                  = var.profile
}

# resource "aws_instance" "s1" {
#   ami = "ami-012b9156f755804f5"
#   instance_type = "t2.micro"
#   key_name = Poc.pem
#   tags = {
#     "Name"="server1"
#   }
#   connection {
    
#   }
# }
resource "aws_vpc" "MyVpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "MySubnet" {
  vpc_id                  = aws_vpc.MyVpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.MyVpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "RouteTable1" {
  vpc_id = aws_vpc.MyVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "MyRouteTable1"
  }
}

resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.MySubnet.id
  route_table_id = aws_route_table.RouteTable1.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.MyVpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust the CIDR block for your VPN connection
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
  }
}

resource "aws_instance" "example_instance" {
  ami           = "ami-08e5424edfe926b43"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = "Poc"  # Replace with the name of your SSH key pair

  subnet_id               = aws_subnet.MySubnet.id
  vpc_security_group_ids  = [aws_security_group.sg.id]
  associate_public_ip_address = true
  
    provisioner "local-exec" {
    command = "sleep 60 && ssh -tt -i /home/shreshth/Downloads/Poc.pem ubuntu@${self.public_ip}"
    
  }

  tags = {
    Name = "MyEC2Instance"
  }
}