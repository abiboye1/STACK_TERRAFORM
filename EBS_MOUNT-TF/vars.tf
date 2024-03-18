variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}
variable "ami" {}

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
  default = "my_key.pub"
}

variable "OwnerEmail" {
  default = "yomioye007@gmail.com"
}

variable "subnet" {
  default = "subnet-084af3f094dd68af5"
  
}

variable "dev_names" {
  default = ["sdb", "sdc", "sdd", "sde", "sdf"]
}

variable "num_ebs_volumes" {
  default = 5
}