### Declare Key Pair
# data "aws_key_pair" "Stack_KP" {
#   key_name   = "stackkp"
# #   public_key = file(var.PATH_TO_PUBLIC_KEY)
# }

resource "aws_key_pair" "Stack_KP" {
  key_name   = "stackkp_blog"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#####################################
####LAUNCH TEMPLATE
#BLOG AUTO SCALING GROUP
resource "aws_launch_template" "BLOG_LAUNCHTEMP" {
  name = "BLOG-LAUNCH-TEMP"
  user_data                 = base64encode(data.template_file.bootstrap2.rendered)
  image_id                  = var.AMI
  instance_type             = "t2.micro"
  vpc_security_group_ids    = [aws_security_group.blog-sg.id]

  tags = {
   Name                   = "Application_Server_Aut"
   Environment            = var.environment
   OwnerEmail             = var.OwnerEmail
}
}

resource "aws_autoscaling_group" "BLOGTERA_ASG" {
  depends_on = [ 
    aws_efs_mount_target.efs_blog_mount,
    aws_db_instance.BLOG_DB
   ]
  launch_template {
   id                       = aws_launch_template.BLOG_LAUNCHTEMP.id 
   version= "$Latest"
  }
  
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  vpc_zone_identifier       = values(var.subnet_ids)
  tag {
    key = "Name"
    value = "BLOG_ASG_INSTANCE"
    propagate_at_launch = true
  }
  target_group_arns         = [aws_lb_target_group.BLOGTERA_tg.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 30
}





