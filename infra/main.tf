#provider "aws" {
#    region = "ca-central-1"
#}

resource "aws_instance" "testdeploy" {
    ami = "ami-05ed7c410d6798451"
    instance_type = "t2.micro"
    key_name = "keypair"
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_security_group.allow_rdp.id]

tags = {
     Name = "WinServer_AnsibleTst"
  }
}

resource "aws_instance" "ansiblecont" {
    ami = "ami-0a2e7efb4257c0907"
    instance_type = "t2.micro"
    key_name = "keypair"
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_security_group.allow_port_22.id]

tags = {
     Name = "Ansible_Controller"
  }
}