  provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0a7cf821b91bcccbc"
  instance_type = "t2.micro"
  key_name = "Talachavi"
  //security_groups = [ "demo-sg" ]
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id = aws_subnet.demo-pub-subnet-01.id 
  for_each = toset(["Jenkins-Master" , "Jenkins-Slave" , "Ansible"])
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_security_group" "demo-sg" {
    name = "demo-sg"
    vpc_id = aws_vpc.demo-vpc.id
    description = "ssh access"

    ingress {
        description = "ssh access"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
      Name = "demo-sg"
    }
}

resource "aws_vpc" "demo-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "demo-vpc"
    } 
}

resource "aws_subnet" "demo-pub-subnet-01" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "demo-pub-subnet-01"
    }
  
}
resource "aws_subnet" "demo-pub-subnet-02" {
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"
    tags = {
      Name = "demo-pub-subnet-02"
    }
  
}
resource "aws_internet_gateway" "demo-igw" {
    vpc_id = aws_vpc.demo-vpc.id
    tags = {
        Name = "demo-igw"
    }
  
}
resource "aws_route_table" "demo-pub-rt" {
    vpc_id = aws_vpc.demo-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo-igw.id
    }
  
}
resource "aws_route_table_association" "demo-rt-pu-subnet-01" {
    subnet_id = aws_subnet.demo-pub-subnet-01.id
    route_table_id = aws_route_table.demo-pub-rt.id
  
}
resource "aws_route_table_association" "demo-rt-pu-subnet-02" {
    subnet_id = aws_subnet.demo-pub-subnet-02.id
    route_table_id = aws_route_table.demo-pub-rt.id
}
