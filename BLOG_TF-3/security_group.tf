####SECURITY GROUP STACK-SG
resource "aws_security_group" "blog-sg" {
  vpc_id = var.vpc_id
  name        = "Wordpress-WebDMZ-Blog"
  description = "Stack IT Security Group For Wordpress System"
  egress = []
  tags = {
    Name = "Wordpress-WebDMZ"
  }
}
###################################################
#INBOUND RULES
#SSH
resource "aws_security_group_rule" "ssh1" {
  security_group_id = aws_security_group.blog-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}
#NFS
resource "aws_security_group_rule" "nfs1" {
  security_group_id = aws_security_group.blog-sg.id
  type = "ingress"
  protocol = "tcp"
  from_port = 2049
  to_port = 2049
  cidr_blocks = ["0.0.0.0/0"]
}
#HTTP
resource "aws_security_group_rule" "http1" {
  security_group_id = aws_security_group.blog-sg.id
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "mysql1" {
  security_group_id = aws_security_group.blog-sg.id
  type = "ingress"
  protocol = "tcp"
  from_port = 3306
  to_port = 3306
  cidr_blocks = ["0.0.0.0/0"]
}
#HTTPS
resource "aws_security_group_rule" "https1" {
  security_group_id = aws_security_group.blog-sg.id
  type = "ingress"
  protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_blocks = ["0.0.0.0/0"]
}
#OUTBOUND RULE
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.blog-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  # Indicates all protocols
  cidr_blocks       = ["0.0.0.0/0"]
}
