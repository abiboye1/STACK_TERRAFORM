#EFS CREATION
resource "aws_efs_file_system" "efs_blog" {
  creation_token    = "EFSBLOG"
 
  tags = {
    Name = "EFS_BLOG"
  }
}
resource "aws_efs_mount_target" "efs_blog_mount" {
  for_each = var.subnet_ids
  file_system_id = aws_efs_file_system.efs_blog.id
  subnet_id = each.value
  security_groups = [aws_security_group.blog-sg.id]
}