resource "aws_kinesis_stream" "api_stream" {
  name             = "apigw_kinesis"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }


}
resource "aws_kinesis_stream_consumer" "apigw_consumer" {
  name       = "apigw_consumer"
  stream_arn = aws_kinesis_stream.api_stream.arn
}