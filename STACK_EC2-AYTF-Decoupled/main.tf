### Declare Key Pair
locals {
  ServerPrefix = ""
}

resource "aws_key_pair" "Stack_KP" {
  key_name   = "stack_dep_kp"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_security_group" "stack-sg" {
  vpc_id      = var.default_vpc_id
  name        = "stack_terra_DMZ"
  description = "Security group for Application Servers"

  ingress {
    description       = "SSH from VPC"
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    cidr_blocks       = ["0.0.0.0/0"]
    }

  ingress {
    description       = "Aurora/MySQL"
    protocol          = "tcp"
    from_port         = 3306
    to_port           = 3306
    cidr_blocks       = ["0.0.0.0/0"]
    }

  ingress {
    description       = "EFS mount target"
    protocol          = "tcp"
    from_port         = 2049
    to_port           = 2049
    cidr_blocks       = ["0.0.0.0/0"]
    }

  ingress {
    description       = "HTTP from VPC"
    protocol          = "tcp"
    from_port         = 80
    to_port           = 80
    cidr_blocks       = ["0.0.0.0/0"]
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  timeouts {
    delete = "2m"
  }

  lifecycle {
    create_before_destroy = true
  }
}

######### CLIXX BLOCK ###########
##### DATABASE
resource "aws_db_instance" "CliXX" {
  count = var.stack_controls["clixx_create"] == "Y" ? 1 : 0
  snapshot_identifier = "${data.aws_db_snapshot.clixxdb.id}"
  instance_class      = "db.t2.micro" 
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.stack-sg.id]
}

resource "aws_efs_file_system" "clixx_efs" {
  count = var.stack_controls["clixx_create"] == "Y" ? 1 : 0
  availability_zone_name = var.availability_zone
  creation_token = "stack-terra-EFS"
  tags = {
    Name = "stack_EFS"
  }
}

resource "aws_efs_mount_target" "clixx_mount" {
  count = var.stack_controls["clixx_create"] == "Y" ? 1 : 0
  file_system_id  = aws_efs_file_system.clixx_efs[count.index].id
  subnet_id       = var.subnet[0]
  security_groups = [aws_security_group.stack-sg.id]
}


######### BLOG BLOCK ###########
##### DATABASE
resource "aws_db_instance" "Blog" {
  count = var.stack_controls["blog_create"] == "Y" ? 1 : 0
  snapshot_identifier = "${data.aws_db_snapshot.blogdb.id}"
  instance_class      = "db.t2.micro" 
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.stack-sg.id] 
}

resource "aws_efs_file_system" "blog_efs" {
  count = var.stack_controls["blog_create"] == "Y" ? 1 : 0
  availability_zone_name = var.availability_zone
  creation_token = "blog-terra-EFS"
  tags = {
    Name = "blog_EFS"
  }
}

resource "aws_efs_mount_target" "blog_mount" {
  count = var.stack_controls["blog_create"] == "Y" ? 1 : 0
  file_system_id  = aws_efs_file_system.blog_efs[count.index].id
  subnet_id       = var.subnet[0]
  security_groups = [aws_security_group.stack-sg.id]
}



# resource "aws_ebs_volume" "app-data" {
#   count             = var.num_ebs_volumes
#   availability_zone = aws_instance.server[0].availability_zone
#   size              = var.ebs_volumes[element(keys(var.ebs_volumes), count.index)]

#   tags = {
#     Name = "/dev/sdh-${element(keys(var.ebs_volumes), count.index)}"
#   }
# }

# #attach volumes to the instance
# resource "aws_volume_attachment" "app-vol" {
#   count        = var.num_ebs_volumes
#   device_name  = "/dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)}"
#   volume_id    = aws_ebs_volume.app-data[count.index].id
#   instance_id  = aws_instance.server[0].id
#   force_detach = true
# }

# resource "null_resource" "mount_ebs_volumes" {
#   depends_on = [aws_volume_attachment.app-vol]
#   count      = var.num_ebs_volumes

#   connection {
#     type        = "ssh"
#     user        = "ec2-user"  
#     private_key = file(var.PATH_TO_PRIVATE_KEY)
#     host        = aws_instance.server[0].public_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "set -e",
#       "set -x",
#       "sudo mkdir -p /u0${count.index + 1}",  #create a mount point

#       #format the volume with ext4 filesystem
#       "sudo mkfs -t ext4 /dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)}",

#       #check if the entry already exists in /etc/fstab
#       "if ! grep -q '/dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)} /u0${count.index + 1}' /etc/fstab; then",

#       #add the entry to /etc/fstab
#       "echo '/dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)} /u0${count.index + 1} ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab",  # Add entry to /etc/fstab
#       "fi",

#     ]
#   }
# }

# resource "null_resource" "mount_all_volumes" {
#   depends_on = [null_resource.mount_ebs_volumes]

#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = file(var.PATH_TO_PRIVATE_KEY)
#     host        = aws_instance.server[0].public_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo mount -a",  # Mount all filesystems listed in /etc/fstab
#     ]
#   }
# }



# resource "aws_ebs_volume" "blog-data" {
#   count             = var.num_ebs_volumes
#   availability_zone = aws_instance.blogserver[0].availability_zone
#   size              = var.ebs_volumes[element(keys(var.ebs_volumes), count.index)]

#   tags = {
#     Name = "/dev/sdh-${element(keys(var.ebs_volumes), count.index)}"
#   }
# }

# #attach volumes to the instance
# resource "aws_volume_attachment" "blog-vol" {
#   count        = var.num_ebs_volumes
#   device_name  = "/dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)}"
#   volume_id    = aws_ebs_volume.blog-data[count.index].id
#   instance_id  = aws_instance.blogserver[0].id
#   force_detach = true
# }

# resource "null_resource" "blog_ebs_volumes" {
#   depends_on = [aws_volume_attachment.blog-vol]
#   count = var.num_ebs_volumes

#   connection {
#     type        = "ssh"
#     user        = "ec2-user"  
#     private_key = file(var.PATH_TO_PRIVATE_KEY)
#     host        = aws_instance.blogserver[0].public_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "set -e",
#       "set -x",
#       "sudo mkdir -p /u0${count.index + 1}",  #create a mount point

#       #format the volume with ext4 filesystem
#       "sudo mkfs -t ext4 /dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)}",

#       #check if the entry already exists in /etc/fstab
#       "if ! grep -q '/dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)} /u0${count.index + 1}' /etc/fstab; then",

#       #add the entry to /etc/fstab
#       "echo '/dev/sd${element(["f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"], count.index)} /u0${count.index + 1} ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab",  # Add entry to /etc/fstab
#       "fi",

#     ]
#   }
# }

# resource "null_resource" "mount_blog_volumes" {
#   depends_on = [null_resource.blog_ebs_volumes]

#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = file(var.PATH_TO_PRIVATE_KEY)
#     host        = aws_instance.blogserver[0].public_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo mount -a",  # Mount all filesystems listed in /etc/fstab
#     ]
#   }
# }

