from datetime import datetime
import calendar
import random
import time
import json
import boto3
		

	# The kinesis stream I defined in asw console
stream_name = 'apigw_kinesis'
	
# event = {

#   'queryStringParameters':{
#     'First_Name': 'ho',
#     'Last_Name':'van',
#     'Phone_Number':'123',
#     'Company_Name': 'fpt'
#   }
# }
k_client = boto3.client('kinesis', endpoint_url="http://host.docker.internal:4566",region_name = "ap-southeast-1")
	
Partition_key = 'API'
def lambda_handler(event,context):

    First_Name = event['queryStringParameters']['First_Name']
    Last_Name = event['queryStringParameters']['Last_Name']
    Phone_Number = event['queryStringParameters']['Phone_Number']
    Company_Name = event['queryStringParameters']['Company_Name']
    Job_Type = event['queryStringParameters']['Job_Type']
    payload = {
	            'First_name': First_Name,
	            'Last_Name': Last_Name,
	            'Phone_Number': Phone_Number,
              'Company_Name': Company_Name,
              'Job_Type' : Job_Type
	            }
    put_to_stream(payload, Partition_key)
    return {
        'statusCode': 200,
        'body': payload
    }
	


	        
def put_to_stream(payload, Partition_key):
	        
	# print (payload)
	
	put_response = k_client.put_record(StreamName=stream_name, Data =json.dumps(payload),PartitionKey=Partition_key)
