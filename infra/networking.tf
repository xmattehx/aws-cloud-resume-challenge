//Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
}

//Create subnet
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "subnet1"
  }
}

//Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gw"
  }
}

//Reoute Table
resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "RouteTable"
  }
}

//Route Table Association
resource "aws_route_table_association" "rt_a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.routetable.id
}

//RDP Security Group
resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow rdp inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_rdp"
  }
}

//GetMyLocalIP
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

//Allow RDP in from VPC CIDR Block
resource "aws_vpc_security_group_ingress_rule" "allow_rdp_ipv4" {
  security_group_id = aws_security_group.allow_rdp.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

//Allow RDP from Home IP
resource "aws_vpc_security_group_ingress_rule" "allow_rdp_ipv4_home" {
  security_group_id = aws_security_group.allow_rdp.id
  cidr_ipv4         = "${chomp(data.http.myip.response_body)}/32"
  from_port         = 3389
  ip_protocol       = "tcp"
  to_port           = 3389
}

//Allow all traffic out on all ports
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_port3389" {
  security_group_id = aws_security_group.allow_rdp.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

//Port 22 Security Group
resource "aws_security_group" "allow_port_22" {
  name        = "allow_port 22"
  description = "Allow port 22 inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_Port_22"
  }
}

//Allow Port 22 in from VPC CIDR Block
resource "aws_vpc_security_group_ingress_rule" "allow_22_ipv4" {
  security_group_id = aws_security_group.allow_port_22.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

//Allow Port 22 in from Home IP
resource "aws_vpc_security_group_ingress_rule" "allow_22_ipv4_home" {
  security_group_id = aws_security_group.allow_port_22.id
  cidr_ipv4         = "${chomp(data.http.myip.response_body)}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

//Allow All traffic out
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_port22" {
  security_group_id = aws_security_group.allow_port_22.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
