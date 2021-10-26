variable "s3_bucket_name" {
  description = "S3 bucket name"
  default = "ostasenko-training-bucket"
  type = string
}

variable "dynamodb_script" {
  description = "A name of a dynamodb script"
  default = "dynamodb-script.sh"
  type = string
}

variable "rds_script" {
  description = "A name of a SQL RDS script"
  default = "rds-script.sql"
  type = string
}


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

variable "rds_engine" {
  default = "postgres"
  type = string
}

variable "rds_engine_version" {
  default = "12.8"
  type = string
}

variable "rds_instance_class" {
  default = "db.t2.micro"
  type = string
}

variable "rds_name" {
  default = "awstraining"
  type = string
}

variable "rds_username" {
  default = "postgres"
  type = string
}

variable "rds_password" {
  default = "postgres"
  type = string
}
