### Declare Key Pair
# data "aws_key_pair" "Stack_KP" {
#   key_name   = "stackkp"
# #   public_key = file(var.PATH_TO_PUBLIC_KEY)
# }

resource "aws_key_pair" "Stack_KP" {
  key_name   = "stackkp_new"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#CLIXX AUTO SCALING GROUP
resource "aws_launch_template" "CLIXX_LAUNCHTEMP" {
  name = "CLIXX-LAUNCH-TEMP"
  user_data                 = base64encode(data.template_file.bootstrap.rendered)
  image_id                  = var.ami
  instance_type             = "t2.micro"
  vpc_security_group_ids    = [aws_security_group.stack-sg.id]
  tags = {
    
  }
}

resource "aws_autoscaling_group" "CLIXXTERA_ASG" {
  depends_on = [ 
    aws_efs_mount_target.efs_clixx_mount,
    aws_db_instance.CLIXX_DB
   ]
  launch_template {
   id                       = aws_launch_template.CLIXX_LAUNCHTEMP.id 
   version= "$Latest" 
  }
  
  min_size                  = 2
  max_size                  = 3
  desired_capacity          = 2
  vpc_zone_identifier       = values(var.subnet_ids)
  tag {
    key = "Name"
    value = "CLIXX_ASG_INSTANCE"
    propagate_at_launch = true
  }
  target_group_arns         = [aws_lb_target_group.CLIXXTERA_tg.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 30
}