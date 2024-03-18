data "aws_ami" "stack_ami" {
  owners     = ["self"]
  name_regex = "^ami-image-.*"
  most_recent = true
  filter {
    name   = "name"
    values = ["ami-image-*"]
  }
}

data "aws_subnets" "stack_sub" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "stack_sub" {
  for_each = toset(data.aws_subnets.stack_sub.ids)
  id       = each.value
}

data "aws_autoscaling_groups" "BLOGTERA_ASG" {
  names = ["BLOGTERA_ASG"]  
}