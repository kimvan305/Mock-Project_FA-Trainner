--upload csv to s3

aws --endpoint-url=http://localhost:4566 s3 cp C:\Users\WINDOW\Documents\GitHub\Mock-Project_FA-Trainner\test.csv  s3://csv-bucket
aws --endpoint-url=http://localhost:4566 s3 cp ..\test.csv  s3://csv-bucket

--scan item in table of dynamodb

aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name='count_row_csv_dynamodb' 

--list objects in s3

aws --endpoint-url=http://localhost:4566 s3 ls s3://csv-bucket

-- lambda
 aws --endpoint-url=http://localhost:4566 lambda list-functions

-- reference of boto3.client:
aws
https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#client

-- install new library in Python: py -m pip install

ENDPOINT= http://localhost:4566/restapis/rcniv5ij66/dev/_user_request_/mydemo_apigw
echo "Testing GET:"
curl -i ${ENDPOINT}
