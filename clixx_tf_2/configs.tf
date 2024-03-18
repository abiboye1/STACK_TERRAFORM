data "template_file" "bootstrap" {
  template = file(format("%s/scripts/clixx_bootstrap.tpl", path.module))
  vars={
    GIT_REPO="https://github.com/stackitgit/CliXX_Retail_Repository.git"
    FILE_SYSTEM_ID = aws_efs_file_system.efs_clixx.id
    CLIXX_LB = aws_lb.CLIXX_lb.dns_name
    RDS_INSTANCE = aws_db_instance.CLIXX_DB.endpoint
    DB_NAME=var.db_name
    DB_USER=var.db_username
    DB_PASSWORD=var.db_password
    DB_HOST= local.DB_HOST_CLIXX
    MOUNT_POINT=var.mount_point
    REGION=var.AWS_REGION
}
}

locals {
  DB_HOST_CLIXX = replace(aws_db_instance.CLIXX_DB.endpoint, ":3306", "")
}