#RESTORING RDS FROM SNAPSHOT
resource "aws_db_instance" "BLOG_DB" {
  identifier = "wordpress"
  instance_class = "db.t3.micro"
  db_name = ""
  snapshot_identifier = data.aws_db_snapshot.BLOGSNAP.id
  skip_final_snapshot = true
  vpc_security_group_ids = ["${aws_security_group.blog-sg.id}"]
  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}

data "aws_db_snapshot" "BLOGSNAP" {
  db_snapshot_identifier = var.snapshot_id
  most_recent            = true
}


# # Copy existing database snapshot to another region
# resource "aws_db_snapshot_copy" "snapshot" {
#   source_db_snapshot_identifier = var.snapshot_id
#   target_db_snapshot_identifier = "my-blog-snapshot-abib-tf"  # Specify the name for the copied snapshot
# }

# # Restore database from the copied snapshot
# resource "aws_db_instance" "blog" {
#   identifier = var.blog-identifier
#   allocated_storage = 20
#   engine            = "mysql"
#   instance_class    = "db.t3.micro"
#   db_name           = var.db_name
#   password          = var.db_password
#   username          = var.db_username
#   skip_final_snapshot = true
#   vpc_security_group_ids = [aws_security_group.tf_blog_dmz.id]
#   backup_retention_period = 0
#   parameter_group_name    = aws_db_parameter_group.par_grp.name
#   # snapshot_identifier = aws_db_snapshot_copy.snapshot.target_db_snapshot_identifier  # Use the identifier of the copied snapshot as the source for restoration  
#   snapshot_identifier = aws_db_snapshot_copy.snapshot.id
#   db_subnet_group_name = aws_db_subnet_group.sub_grp.name
# }

# resource "aws_db_parameter_group" "par_grp" {
#   name = "default-mysql8-0"
#   family = "mysql8.0"

#   parameter {
#     name = "time_zone"
#     value = "UTC"
#   }
# }

# output "rds_endpoint" {
#   value = aws_db_instance.blog.endpoint
# }

# resource "aws_db_subnet_group" "sub_grp" {
#   name       = "main"
#   # subnet_ids = values(var.subnet_ids)
#   subnet_ids = var.subnet_ids
#   # subnet_ids =[var.subnet_ids[0], var.subnet_ids[1]]

#   tags = {
#     Name = "My DB subnet group"
#   }
# }