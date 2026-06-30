provider "aws" {
    region ="eu-west-3"
}

resource "aws_instance" "example" {
    ami = "ami-0e1c4170d9c01184b"
    instance_type = "t3.micro"

    user_data_replace_on_change= <<- EOF
    #/bin/bash
    echo "Hello World" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF
    
    tags {
        Name = "terraform-example"
    }
  
}