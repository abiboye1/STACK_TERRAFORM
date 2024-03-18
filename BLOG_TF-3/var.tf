variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}
variable "AMI" {
  
}


variable "environment" {
  default = "dev"
}

variable "vpc_id" {
  default = "vpc-02887ad5377b2ce9d"
}

variable "system" {
  default = "Retail Reporting"
}

variable "subsystem" {
  default = "CliXX"
}

variable "availability_zone" {
  default = "us-east-1c"
}
variable "subnets_cidrs" {
  type = list(string)
  default = [
    "172.31.80.0/20"
  ]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "OwnerEmail" {
  default = "yomioye007@gmail.com"
}

# variable "AMIS" {
#   type = map(string)
#   default = {
#     us-east-1 = "ami-image-1.0"
#     us-west-2 = "ami-06b94666"
#     eu-west-1 = "ami-844e0bf7"
#   }
# }

variable "subnet" {
  default = ["subnet-084af3f094dd68af5", "subnet-0d74cb9b657f5fd81"]
  
}


variable "snapshot_id" {
    default = "arn:aws:rds:us-east-1:730335195244:snapshot:snap-03-04" 
}

variable "blog-identifier" {
  default = "newretail"
  type = string
}

variable "db_password" {
  default = "W3lcome123"
}

variable "db_username" {
  default = "admin"
}

variable "db_name" {
  default = "wordpressdb"
}

variable "rds_instance" {
  default = "newretail.cxa6ui6m6ilk.us-east-1.rds.amazonaws.com"
}

variable "dev_names" {
  # default = ["sdb", "sdc", "sdd", "sde", "sdf"]
  default = ["sdb"]
}

variable "mount_point" {
  default = "/var/www/html"
}


variable "subnet_id" {
  type = list(string)
  default = [
    "subnet-084af3f094dd68af5",
    "subnet-0968e42ba44d724f5",
    "subnet-0a446bdb58c6c05c4",
    "subnet-0b6dd1ae9c524e818",
    "subnet-0d74cb9b657f5fd81",
    "subnet-0d831b2a0653ec14f"
  ]     
}

variable "subnet_ids" {
  type = map(string)
  default = {
    "1c" = "subnet-084af3f094dd68af5",
    "1d" = "subnet-0968e42ba44d724f5"
    # "1e" = "subnet-0a446bdb58c6c05c4",
    # "1a" = "subnet-0b6dd1ae9c524e818",
    # "1b" = "subnet-0d74cb9b657f5fd81",
    # "1f" = "subnet-0d831b2a0653ec14f"
  }     
}
