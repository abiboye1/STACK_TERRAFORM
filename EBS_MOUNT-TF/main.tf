# module "STACK-TAGS" {
#   source="github.com/stackitgit/stackterraform.git?ref=stackmodules/STACK_TAGS"
#   #  source="./STACK_TAGS"
#   required_tags={
#     Environment=var.environment,
#     OwnerEmail=var.OwnerEmail,
#     System=var.subsystem,
#     Backup=var.backup,
#     Region=var.region
#   }
# }

### Declare Key Pair
data "aws_key_pair" "Stack_KP" {
  key_name   = "stackkp"
  # public_key = file(var.PATH_TO_PUBLIC_KEY)
}


resource "aws_security_group" "stack-sg" {
#  vpc_id = var.vpc
  name        = "Stack-WebDMZ-ebs"
  description = "Stack IT Security Group For CliXX System"
}
resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.stack-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "server" {
  ami                     = var.ami
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.stack-sg.id]
  user_data               = base64encode(file("${path.module}/ebs_script.sh"))
  key_name                = data.aws_key_pair.Stack_KP.key_name
  subnet_id               = var.subnet
 root_block_device {
    volume_type           = "gp2"
    volume_size           = 10
    delete_on_termination = true
    encrypted             = false
  }
  tags = {
   Name                   = "Application_Server_Aut"
   Environment            = var.environment
   OwnerEmail             = var.OwnerEmail
}
}


















