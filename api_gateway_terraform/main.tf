# resource "aws_glue_catalog_database" "aws_glue_database" {
# name = "apigw_catalogdatabase"
# }


# resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
# name          = "catalogtable"
# database_name = aws_glue_catalog_database.aws_glue_database.name
# depends_on = [
#   aws_glue_catalog_database.aws_glue_database
# ]

# #   table_type = "EXTERNAL_TABLE"

# #   parameters = {
# #     EXTERNAL              = "TRUE"
# #     "parquet.compression" = "SNAPPY"
# #   }

# storage_descriptor {
#   location      = "s3://apigateway-bucket"
#   input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
#   output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

#   # ser_de_info {
#   #   name                  = "my-stream"
#   #   serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

#   #   parameters = {
#   #     "serialization.format" = 1
#   #   }
#   # }

#   columns {
#     name = "first_name"
#     type = "string"
#   }

#   columns {
#     name = "last_name"
#     type = "string"
#   }

#   columns {
#     name    = "phone_number"
#     type    = "int"
#     comment = ""
#   }

#   columns {
#     name    = "company_name"
#     type    = "string"
#     comment = ""
#   }

#   columns {
#     name    = "job_type"
#     type    = "string"
#     comment = ""
#   }
# }
# }

