# resource "aws_volume_attachment" "app-vol" {
#   count        = var.num_ebs_volumes
#   device_name  = "/dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)}"
#   volume_id    = aws_ebs_volume.app-data[count.index].id
#   instance_id  = aws_instance.server.id
#   force_detach = true
# }
# resource "null_resource" "mount_ebs_volumes" {
#   depends_on = [aws_volume_attachment.app-vol]
#   count = var.num_ebs_volumes
#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = file(var.PATH_TO_PRIVATE_KEY)
#     host        = aws_instance.server.public_ip
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "set -e",
#       "set -x",
#       "sudo mkdir -p /u0${count.index + 1}",  #create a mount point
#       #format the volume with ext4 filesystem
#       "sudo mkfs -t ext4 /dev/sd${element(["f", "g", "h", "i", "j"], count.index)}",