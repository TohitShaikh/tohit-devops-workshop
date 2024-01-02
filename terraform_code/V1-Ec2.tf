provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
  ami = "ami-0a0f1259dd1c90938"
  instance_type = "t2.micro"
  key_name = "Talachavi"
}
