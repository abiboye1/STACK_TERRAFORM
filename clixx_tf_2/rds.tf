#RESTORING RDS FROM SNAPSHOT
resource "aws_db_instance" "CLIXX_DB" {
  identifier = var.clixx-identifier
  instance_class = "db.t3.micro"
  db_name = ""
  snapshot_identifier = data.aws_db_snapshot.database_snapshot.id
  skip_final_snapshot = true
  vpc_security_group_ids = ["${aws_security_group.stack-sg.id}"]
  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}

data "aws_db_snapshot" "database_snapshot" {
  db_snapshot_identifier = var.snapshot_id
  # db_instance_identifier = aws_db_instance.database-instance.identifier
  most_recent            = true
  snapshot_type          = "manual"
}