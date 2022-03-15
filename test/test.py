#import boto3, botocore
import logging
import boto3, csv, botocore
from botocore.exceptions import ClientError
import urllib.parse

# access s3 
s3 = boto3.client('s3',endpoint_url="http://localhost:4566",region_name = "ap-southeast-2")
dynamodb = boto3.client('dynamodb',endpoint_url="http://localhost:4566",region_name = "ap-southeast-2")
#response = s3.list_buckets()
event = {
  "Records": [
    {
      "eventVersion": "2.0",
      "eventSource": "aws:s3",
      "awsRegion": "us-west-2",
      "eventTime": "1970-01-01T00:00:00.000Z",
      "eventName": "ObjectCreated:Put",
      "userIdentity": {
        "principalId": "EXAMPLE"
      },
      "requestParameters": {
        "sourceIPAddress": "127.0.0.1"
      },
      "responseElements": {
        "x-amz-request-id": "EXAMPLE123456789",
        "x-amz-id-2": "EXAMPLE123/5678abcdefghijklambdaisawesome/mnopqrstuvwxyzABCDEFGH"
      },
      "s3": {
        "s3SchemaVersion": "1.0",
        "configurationId": "testConfigRule",
        "bucket": {
          "name": "bucket-csv",
          "ownerIdentity": {
            "principalId": "EXAMPLE"
          },
          "arn": "arn:aws:s3:::example-bucket"
        },
        "object": {
          "key": "test6.csv",
          "size": 1024,
          "eTag": "0123456789abcdef0123456789abcdef",
          "sequencer": "0A1B2C3D4E5F678901"
        }
      }
    }
  ]
}



# read csv via get_objects method, import csv to read file
#def handler(event, contex):
def count_row_s3(bucket_s3,key_s3):
    response_1=s3.get_object(Bucket=bucket_s3,Key=key_s3)["Body"].read()
    count = response_1.decode('utf8').count('\n')-1
    return count
def put_dynamodb(num):
    #table = dynamodb.Table('count-row-csv')
    response = dynamodb.put_item(TableName="count_row_csv",Item=
    {
        'row': {
            'N': str(num)}
           }
            )
    return response
def lambda_handler(event):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    try:
        count=count_row_s3(bucket,key)
        put_dynamodb(count)
        
        #return response['ContentType']
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
lambda_handler(event)
response_pr = dynamodb.query(TableName="count_row_csv")

print(response_pr)

#print('Existing buckets:')
#for bucket in response['Buckets']:
#print(f'  {bucket["Name"]}')