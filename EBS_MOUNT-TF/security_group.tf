# # Create Security Group 
# resource "aws_security_group" "tf_ebs_dmz" {
#   name        = "TERRAFORM-DMZ"
#   description = "SG for Terraform"

#   ingress {
#     description      = "Allow SSH inbound traffic"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }


#   egress {
#     description      = "Allow all outbound traffic"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "terraform-DMZ"
#   }
# }