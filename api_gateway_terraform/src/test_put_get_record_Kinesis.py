from datetime import datetime
import calendar
import random
import time
import json
import boto3
		

	# The kinesis stream I defined in asw console
stream_name = 'apigw_kinesis'
Partition_key = 'API'	
event = {
  'queryStringParameters':{
    'First_Name': 'ho',
    'Last_Name':'van',
    'Phone_Number':'123',
    'Company_Name': 'fpt'
  }
}
k_client = boto3.client('kinesis', endpoint_url="http://localhost:4566",region_name = "ap-southeast-1")
	

def lambda_handler(event):

    First_Name = event['queryStringParameters']['First_Name']
    Last_Name = event['queryStringParameters']['Last_Name']
    Phone_Number = event['queryStringParameters']['Phone_Number']
    Company_Name = event['queryStringParameters']['Company_Name']
    # Job_Type = event['queryStringParameters']['Job_Type']
    payload = {
	            'First_name': First_Name,
	            'Last_Name': Last_Name,
	            'Phone_Number': Phone_Number,
              'Company_Name': Company_Name,
            #   'Job_Type' : Job_Type
	            }
    put_to_stream(payload, Partition_key)
    read_stream(stream_name)
    # return {
    #     'statusCode': 200,
    #     'body': read_kstream
    # }
	
def read_stream(k_stream_name):
    response = k_client.describe_stream(StreamName=k_stream_name)
    my_shard_id = response['StreamDescription']['Shards'][0]['ShardId']
    # We use ShardIteratorType of LATEST which means that we start to look
	# at the end of the stream for new incoming data. Note that this means
	# you should be running the this lambda before running any write lambdas
	#
    shard_iterator = k_client.get_shard_iterator(StreamName=stream_name,
	                                                      ShardId=my_shard_id,
	                                                      ShardIteratorType='TRIM_HORIZON')
    # get your shard number and set up iterator

    my_shard_iterator = shard_iterator['ShardIterator']
    # print(my_shard_iterator)

    record_response = k_client.get_records(
             ShardIterator=my_shard_iterator,
             Limit=100
        )
    # print(record_response)
    record_response_1 = k_client.get_records(
               ShardIterator=record_response['NextShardIterator'],
               Limit=100) 
    # print(json.loads(record_response['Records']))
    for record in record_response['Records']:

        print(json.loads(record['Data']))


	        
def put_to_stream(payload, Partition_key):
	        
	# print (payload)
	put_response = k_client.put_record(StreamName=stream_name, Data =json.dumps(payload),PartitionKey=Partition_key)
    # print(put_response['ShardId'])

lambda_handler(event)
