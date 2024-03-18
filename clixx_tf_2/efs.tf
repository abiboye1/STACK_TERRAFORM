#EFS CREATION
resource "aws_efs_file_system" "efs_clixx" {
  creation_token    = "EFSCLIXX"
 
  tags = {
    Name = "EFS_CLIXX"
  }
}
resource "aws_efs_mount_target" "efs_clixx_mount" {
  for_each = var.subnet_ids
  file_system_id = aws_efs_file_system.efs_clixx.id
  subnet_id = each.value
  security_groups = [aws_security_group.stack-sg.id]
}