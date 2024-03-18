# data "template_file" "bootstrap" {
#   template = base64encode(file(format("%s/scripts/bootstrap.tpl", path.module)))
#   vars={
#     GIT_REPO="https://github.com/abiboye1/MY_STACK_BLOGS.git"
#     file_system_id = aws_efs_file_system.fs.id
#     DB_NAME=var.db_name
#     DB_USER=var.db_username
#     DB_PASSWORD=var.db_password
#     RDS_INSTANCE=var.rds_instance
#     MOUNT_POINT=var.mount_point
#     REGION=var.AWS_REGION
# }
# }

locals {
  DB_HOST_BLOG = replace(aws_db_instance.BLOG_DB.endpoint, ":3306", "")
}
data "template_file" "bootstrap2" {
  template = file(format("%s/scripts/bootstrap.tpl", path.module))

  vars = {
    GIT_REPO    = "https://github.com/abiboye1/MY_STACK_BLOGS.git"
    MOUNT_POINT = var.mount_point
    # EFS_DNS     = aws_efs_file_system.efs_blog.dns_name
    BLOG_LB    = aws_lb.BLOG_lb.dns_name
    DB_NAME="wordpressdb"
    DB_USER="admin"
    DB_PASSWORD="W3lcome123"
    RDS_INSTANCE="wordpress.cxa6ui6m6ilk.us-east-1.rds.amazonaws.com"
    # RDS_INSTANCE     = local.DB_HOST_BLOG
    # DB_NAME=var.db_name
    # DB_USER=var.db_username
    # DB_PASSWORD=var.db_password
    FILE_SYSTEM_ID = aws_efs_file_system.efs_blog.id
    REGION=var.AWS_REGION
  }
}



