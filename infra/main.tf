#provider "aws" {
#    region = "ca-central-1"
#}

resource "aws_instance" "testdeploy" {
    ami = "ami-05ed7c410d6798451"
    instance_type = "t2.micro"

tags = {
     Name = "WinServer_AnsibleTst"
  }
}