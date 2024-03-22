data "aws_ami" "stack_ami" {
  owners      = ["self"]
  name_regex  = "^ami-image-.*"
  most_recent = true
  filter {
    name   = "name"
    values = ["ami-image-*"]
  }
}

data "aws_db_snapshot" "clixxdb" {
  db_snapshot_identifier = var.clixx_snapshot_id
  most_recent            = true
}

data "aws_db_snapshot" "blogdb" {
  db_snapshot_identifier = var.blog_snapshot_id
}

data "aws_subnets" "stack_sub" {
  filter {
    name   = "vpc-id"
    values = [var.default_vpc_id]
  }
}

data "aws_subnet" "stack_sub" {
  for_each = toset(data.aws_subnets.stack_sub.ids)
  id       = each.value
}
