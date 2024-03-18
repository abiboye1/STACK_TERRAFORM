resource "aws_ebs_volume" "vol" {
  for_each = { for idx, dev_name in var.dev_names: idx => dev_name }  

  availability_zone = "us-east-1c"
  size              = 8
  type              = "gp2"
#   device_name = "/dev/${each.value}"
  tags = {
    Name = "HelloWorld"
  }
}

output "volume_ids" {
  value = { for idx, vol in aws_ebs_volume.vol : idx => vol.id }
  
  
}


resource "aws_volume_attachment" "ebs_att" { 
  for_each     = aws_ebs_volume.vol
  device_name = "/dev/${var.dev_names[each.key]}"
  #volume_id   = output.volume_ids[idx]
  volume_id   = each.value.id
  instance_id = aws_instance.server.id
}
#   count        = var.num_ebs_volumes
#   device_name  = "/dev/sd${element(["b", "c", "d", "e", "f"], count.index)}"
#   volume_id    = aws_ebs_volume.app-data[count.index].id
#   instance_id  = aws_instance.server.id
#   force_detach = true
# }
# resource "null_resource" "mount_ebs_volumes" {
#   depends_on = [aws_volume_attachment.ebs_att]
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
#       "sudo mkfs -t ext4 /dev/sd${element(["b", "c", "d", "e", "f"], count.index)}",





