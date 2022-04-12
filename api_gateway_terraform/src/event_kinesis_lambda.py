from __future__ import print_function

import base64
import msgpack
import json

print('Loading function')

event = {
  "invocationId": "invoked123",
  "deliveryStreamArn": "aws:lambda:events",
  "region": "us-west-2",
  "records": [
    {
      "data": "SGVsbG8gV29ybGQ=",
      "recordId": "record1",
      "approximateArrivalTimestamp": 1510772160000,
      "kinesisRecordMetadata": {
        "shardId": "shardId-000000000000",
        "partitionKey": "4d1ad2b9-24f8-4b9d-a088-76e9947c317a",
        "approximateArrivalTimestamp": "2012-04-23T18:25:43.511Z",
        "sequenceNumber": "49546986683135544286507457936321625675700192471156785154",
        "subsequenceNumber": ""
      }
    },
    {
      "data": "SGVsbG8gV29ybGQ=",
      "recordId": "record2",
      "approximateArrivalTimestamp": 151077216000,
      "kinesisRecordMetadata": {
        "shardId": "shardId-000000000001",
        "partitionKey": "4d1ad2b9-24f8-4b9d-a088-76e9947c318a",
        "approximateArrivalTimestamp": "2012-04-23T19:25:43.511Z",
        "sequenceNumber": "49546986683135544286507457936321625675700192471156785155",
        "subsequenceNumber": ""
      }
    }
  ]
}
def lambda_handler(event):
  output = []

  for record in event['records']:
    # payload = msgpack.unpackb(base64.b64decode(record['data']), raw=False)
    # decoded_data = base64.b64decode(record["kinesis"]["data"]).decode("utf-8")

    # Do custom processing on the payload here
    output_record = {
       'recordId': record['recordId'],
       'result': 'Ok',
       'data' : base64.b64decode(record["data"]).decode("utf-8")
      #  'data': base64.b64encode(json.dumps(payload).encode('utf-8') + b'\n').decode('utf-8')
    }
    output.append(output_record)

  print('Successfully processed {} records.'.format(len(event['records'])))
  print({'records': output})
  return {'records': output}
lambda_handler(event)