provider "aws" {
    region ="eu-west-3"
}

resource "aws_instance" "example" {
    ami = "ami-0636a4bea146834e0"
    instance_type = "t3.micro"
  
}