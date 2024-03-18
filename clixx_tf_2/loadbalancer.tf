### APPLICATION LOAD BALANCER
resource "aws_lb" "CLIXX_lb" {
  name               = "CLIXXLB-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = values(var.subnet_ids) # Assuming you want to place the ALB in subnet_1b
  security_groups =  ["${aws_security_group.stack-sg.id}"]
  
  tags = {
    Name = "CLIXXLB"
  }
}

#CLIXX LB LISTENER
resource "aws_lb_listener" "CLIXX_listener" {
  load_balancer_arn = aws_lb.CLIXX_lb.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.CLIXXTERA_tg.arn
  }
}

#CLIXXTERA TARGET GROUP
resource "aws_lb_target_group" "CLIXXTERA_tg" {
  name                     = "CLIXXTERA-tg"
  port                     = 80
  protocol                 = "HTTP"
  vpc_id                   = var.vpc_id
  health_check {
    path                   = "/"
    interval               = 30
    timeout                = 5
    healthy_threshold      = 5
    unhealthy_threshold    = 2
  } 
}