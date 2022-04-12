resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_stream" {
    name        = "apigw_kinesis_firehose_stream"
    destination = "extended_s3"
    kinesis_source_configuration {
      kinesis_stream_arn = aws_kinesis_stream.api_stream.arn
      role_arn = aws_iam_role.kinesis_firehose_role.arn
    }
    extended_s3_configuration {
    role_arn       = aws_iam_role.kinesis_firehose_role.arn
    bucket_arn     = aws_s3_bucket.apigw_bucket.arn
    buffer_size    = 128
    # s3_backup_mode = "Enabled"
    prefix         = "logs/"

    processing_configuration {
      enabled = true

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.kinesis_firehose_data_transformation_lambda.arn}:$LATEST"
        }
      }
    }

    # cloudwatch_logging_options {
    #   enabled         = true
    #   log_group_name  = aws_cloudwatch_log_group.kinesis_firehose_stream_logging_group.name
    #   log_stream_name = aws_cloudwatch_log_stream.kinesis_firehose_stream_logging_stream.name
    # }
    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          hive_json_ser_de {}
        }
      }

      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }

      schema_configuration {
        database_name = aws_glue_catalog_table.aws_glue_catalog_table.database_name
        role_arn      = aws_iam_role.kinesis_firehose_role.arn
        table_name    = aws_glue_catalog_table.aws_glue_catalog_table.name
      }
    }
    }
}

resource "aws_iam_role" "kinesis_firehose_role" {
  name = "kinesis_firehose_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "policy_firehose" {
  name = "policy_firehose"
  role = aws_iam_role.kinesis_firehose_role.name
  # name_prefix = var.iam_name_prefix
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords"
        ],
      "Resource": [
        "arn:aws:kinesis:::${aws_kinesis_stream.api_stream.arn}",
        "arn:aws:kinesis:::${aws_kinesis_stream.api_stream.arn}/*"
        ]
      },
     {
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
        ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.apigw_bucket.id}",
        "arn:aws:s3:::${aws_s3_bucket.apigw_bucket.id}/*"
        ]
  },
  {
      "Effect": "Allow",
      "Action": [
        "glue:GetTableVersions"
        ],
      "Resource": [ "*" ]
      }
  ]
}
EOF
}


