resource "aws_security_group" "sg"{
    tags{
        name= "${var.project_name}-sg"
    }
    vpc_id = "${aws_vpc.main.id}"
    ingress
    {
        to_port = 3306
        from_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.RDS_CIDR}"]
    }
    egress
    {
        to_port= 0
        from_port = 0 
        protocol =  "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }    
    

}
resource "aws_security_group" "lbweb"{
    tags{
        name= "${var.project_name}-lbweb"
    }
    vpc_id = "${aws_vpc.main.id}"
    ingress
    {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.web_CIDR}"]
    }
    ingress {
        to_port = 443
        from_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.web_CIDR}"]
    }
    egress
    {
        to_port= 0
        from_port = 0 
        protocol =  "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }    
    

}
resource "aws_security_group" "applb_sg"{
    tags{
        name= "${var.project_name}-applb_sg"
    }
    vpc_id = "${aws_vpc.main.id}"
    ingress
    {
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.web_CIDR}"]
    }
    ingress {
        to_port = 443
        from_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.web_CIDR}"]
    }
    egress
    {
        to_port= 0
        from_port = 0 
        protocol =  "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }    
}

resource "aws_security_group" "appserverssg"{
    tags{
        name= "${var.project_name}-appserversg"
    }
    vpc_id = "${aws_vpc.main.id}"
    ingress
  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.web_CIDR}"]

  }
  ingress
  {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress
  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "webappserversg"{
    tags{
        name= "${var.project_name}-webappserversg"
    }
    vpc_id = "${aws_vpc.main.id}"
    ingress
  {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress
  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
