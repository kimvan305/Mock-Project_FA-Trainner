#import boto3, botocore
import logging
import boto3, csv, botocore
from botocore.exceptions import ClientError
import urllib.parse

# access s3 
s3 = boto3.client('s3',endpoint_url="http://localhost:4566",region_name = "ap-southeast-2")
dynamodb = boto3.client('dynamodb',endpoint_url="http://localhost:4566",region_name = "ap-southeast-2")
#response = s3.list_buckets()
# read csv via get_objects method, import csv to read file
def count_row_s3(bucket_s3,key_s3):
    response_1=s3.get_object(Bucket=bucket_s3,Key=key_s3)["Body"].read()
    count = response_1.decode('utf8').count('\n')-1
    return count
def put_dynamodb(num):
    #table = dynamodb.Table('count-row-csv')
    response = dynamodb.put_item(TableName="count_row_csv_dynamodb",Item=
    {
        'row': {
            'N': str(num)}
           }
            )
    return response
def lambda_handler(event,context):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    try:
        count=count_row_s3(bucket,key)
        put_dynamodb(count)
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
