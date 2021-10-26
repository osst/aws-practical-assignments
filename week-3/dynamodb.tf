resource "aws_dynamodb_table" "cars-table" {
  name           = "Cars"
  billing_mode   = "PROVISIONED"
  hash_key       = "VIN"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "VIN"
    type = "S"
  }
}