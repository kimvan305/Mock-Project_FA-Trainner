resource "aws_dynamodb_table" "count_row_csv" {
  name           = "count_row_csv"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "row"
  #range_key      = " "

  attribute {
    name = "row"
    type = "N"
  }

  tags = {
    Name        = "dynamodb-table"
    #Environment = "production"
  }
}