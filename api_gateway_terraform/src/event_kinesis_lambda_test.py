import logging
import boto3, csv, botocore
from botocore.exceptions import ClientError
import urllib.parse
import json
import base64

# from api_gateway_terraform.src.apigateway_lambda import lambda_handler

event = {
    "Records": [
        {
            "kinesis": {
                "kinesisSchemaVersion": "1.0",
                "partitionKey": "1",
                "sequenceNumber": "49590338271490256608559692538361571095921575989136588898",
                "data": "SGVsbG8sIHRoaXMgaXMgYSB0ZXN0Lg==",
                "approximateArrivalTimestamp": 1545084650.987
            },
            "eventSource": "aws:kinesis",
            "eventVersion": "1.0",
            "eventID": "shardId-000000000006:49590338271490256608559692538361571095921575989136588898",
            "eventName": "aws:kinesis:record",
            "invokeIdentityArn": "arn:aws:iam::123456789012:role/lambda-role",
            "awsRegion": "us-east-2",
            "eventSourceARN": "arn:aws:kinesis:us-east-2:123456789012:stream/lambda-stream"
        },
        {
            "kinesis": {
                "kinesisSchemaVersion": "1.0",
                "partitionKey": "1",
                "sequenceNumber": "49590338271490256608559692540925702759324208523137515618",
                "data": "VGhpcyBpcyBvbmx5IGEgdGVzdC4=",
                "approximateArrivalTimestamp": 1545084711.166
            },
            "eventSource": "aws:kinesis",
            "eventVersion": "1.0",
            "eventID": "shardId-000000000006:49590338271490256608559692540925702759324208523137515618",
            "eventName": "aws:kinesis:record",
            "invokeIdentityArn": "arn:aws:iam::123456789012:role/lambda-role",
            "awsRegion": "us-east-2",
            "eventSourceARN": "arn:aws:kinesis:us-east-2:123456789012:stream/lambda-stream"
        }
    ]
}
event_1 = {
  'queryStringParameters':{
    'First_Name': 'ho',
    'Last_Name':'van',
    'Phone_Number':'123',
    'Company_Name': 'fpt'
  }
}


def lambda_handler(event_1):
    # payload=base64.b64decode(json.dumps(event['Records'][0]['kinesis']['data']))
    # data = base64.b64encode(event_1)
    s = json.dumps(event_1)
    data =base64.b64encode(s.encode('utf-8'))
    return data
    # payload=base64.b64decode(event['Records'][0]['kinesis']['data'])
    # json_payload = json.dumps(payload)
    # print("Decoded payload: " + str(payload))
    # print(json.dumps())
def lambda_handler_test(event,event_1):
    for record in event["Records"]:
        decoded_data = base64.b64decode(record["kinesis"]["data"]).decode("utf-8")
        print(decoded_data)
    decoded_data_1 = base64.b64decode(lambda_handler(event_1)).decode("utf-8")
    print(decoded_data_1)
    

# lambda_handler(event_1)
lambda_handler_test(event,event_1)

# https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html