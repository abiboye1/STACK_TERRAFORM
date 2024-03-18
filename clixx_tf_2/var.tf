variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}
variable "ami" {}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "clixx-identifier" {
  default = "clixx-tf"
  type = string
}

variable "snapshot_id" {
    default = "arn:aws:rds:us-east-1:730335195244:snapshot:my-clixx-snapshot-abib" 
    #default = "arn:aws:rds:us-east-1:730335195244:snapshot:clixx-ss-3-15-24"
}

variable "mount_point" {
  default = "/var/www/html"
}

# variable "subnet_ids" {
#   type = list(string)
#   default = [
#     "subnet-084af3f094dd68af5",
#     "subnet-0968e42ba44d724f5"
#     # "subnet-0a446bdb58c6c05c4",
#     # "subnet-0b6dd1ae9c524e818",
#     # "subnet-0d74cb9b657f5fd81",
#     # "subnet-0d831b2a0653ec14f"
#   ]     
# }

variable "subnet_ids" {
  type = map(string)
  default = {
    "1c" = "subnet-084af3f094dd68af5",
    "1d" = "subnet-0968e42ba44d724f5",
    "1e" = "subnet-0a446bdb58c6c05c4",
    "1a" = "subnet-0b6dd1ae9c524e818",
    "1b" = "subnet-0d74cb9b657f5fd81",
    "1f" = "subnet-0d831b2a0653ec14f"
  }     
}

variable "vpc_id" {
  default = "vpc-02887ad5377b2ce9d"
}

variable "db_username" {
  default = "wordpressuser"
}

variable "db_password" {
  default = "W3lcome123"
}

variable "db_name" {
  default = "wordpressdb"
}