resource "aws_dynamodb_table" "cars-table" {
  name           = "edu-lohika-training-aws-dynamodb"
  billing_mode   = "PROVISIONED"
  hash_key       = "UserName"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "UserName"
    type = "S"
  }
}