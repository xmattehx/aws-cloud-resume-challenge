provider "aws" {
    region = "ca-central-1"
}

resource "aws_instance" "testdeploy" {
    ami = "ami-0a2e7efb4257c0907"
    instance_type = "t2.micro"

tags = {
    # Name = "Ubuntu"
  }
}