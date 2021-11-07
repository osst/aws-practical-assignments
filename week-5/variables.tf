variable "ec2_ami" {
  default = "ami-0c2d06d50ce30b442"
  type = string
}

variable "ec2_instance_type" {
  default = "t2.micro"
  type = string
}

variable "ec2_key_name" {
  default = "os-keypair"
  type = string
}
