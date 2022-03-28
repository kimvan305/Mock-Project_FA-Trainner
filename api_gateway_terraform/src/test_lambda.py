from __future__ import print_function

import boto3
import json

print('Loading function')


def handler(event, context):
    '''Provide an event that contains the following keys:

      - operation: one of the operations in the operations dict below
      - tableName: required for operations that interact with DynamoDB
      - payload: a parameter to pass to the operation being performed
    '''
    #print("Received event: " + json.dumps(event, indent=2))

    operation = event['operation']

    if 'tableName' in event:
        dynamo = boto3.resource('dynamodb').Table(event['tableName'])

    operations = {
        'create': lambda x: dynamo.put_item(**x),
        'read': lambda x: dynamo.get_item(**x),
        'update': lambda x: dynamo.update_item(**x),
        'delete': lambda x: dynamo.delete_item(**x),
        'list': lambda x: dynamo.scan(**x),
        'echo': lambda x: x,
        'ping': lambda x: 'pong'
    }

    if operation in operations:
        return operations[operation](event.get('payload'))
    else:
        raise ValueError('Unrecognized operation "{}"'.format(operation))

    message = 'Hello {} {}!'.format(event['queryStringParameters']['First_name'], event['queryStringParameters']['Last_name'])  

    return {
        'statusCode': 200,
        'body': message
    }
    #print("Received event: " + json.dumps(event, indent=2))
    # event_1 = base64.b64encode(event).decode("utf-8")
    # print(json.dumps(event))
    # return json.dumps(event)
    # return { 
    #      'message' : 'Hello world'
    #  }


    # operation = event['operation']

    # if 'tableName' in event:
    #     dynamo = boto3.resource('dynamodb').Table(event['tableName'])

    # operations = {
    #     'create': lambda x: dynamo.put_item(**x),
    #     'read': lambda x: dynamo.get_item(**x),
    #     'update': lambda x: dynamo.update_item(**x),
    #     'delete': lambda x: dynamo.delete_item(**x),
    #     'list': lambda x: dynamo.scan(**x),
    #     'echo': lambda x: x,
    #     'ping': lambda x: 'pong'
    # }

    # if operation in operations:
    #     return operations[operation](event.get('payload'))
    # else:
    #     raise ValueError('Unrecognized operation "{}"'.format(operation))